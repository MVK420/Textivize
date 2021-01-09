//
//  SaveView.swift
//  Textivize
//
//  Created by Mozes Vidami on 11/15/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

enum ActiveAlert {
    case first, second
}

struct SaveButton: View {

    @ObservedObject var interstitialService:InterstitialService
    @Environment(\.parrentFunc) var parentFunction
    @State var saveAlert:Bool = false
    @State var areYouSure:Bool = false
    @State var uiimage:UIImage? = nil
    @Binding var rect1: CGRect
    @State var text = "Save"
    @State private var activeAlert: ActiveAlert = .first
    
    var body: some View {
        Text("")
            .alert(isPresented: self.$saveAlert) {
            //self.presentAlert()
                self.presentAlert()
        }.onReceive(NotificationCenter.default.publisher(for: NSNotification.canSaveImage)) { _ in
            self.onDismissedAd()}
            
        Button(action: {self.areYouSure.toggle()}) {
            Text("Save")
        }.alert(isPresented: self.$areYouSure) {
            //self.presentAlert()
            self.presentAreYouSure()
        }//.onReceive(NotificationCenter.default.publisher(for: NSNotification.canSaveImage)) { _ in
          //  self.onDismissedAd()}
    }
    
    private func onDismissedAd() {
        self.parentFunction?()
        self.saveAlert.toggle()
    }
    
    private func onTapSaveButton() {
        if !self.interstitialService.showAd() {
            ///Ad was not played
            #warning("when ad is not played, must do something")
        }
    }
    
    private func presentAreYouSure() -> Alert {
        return Alert(title: Text("Are you sure you want to save?"), message: Text(Constants.saveAlertMessage), primaryButton: .default(Text("Yes")) {
            self.onTapSaveButton()
        }, secondaryButton: .default(Text("No")) {
            self.onTapSaveButton()
        })
    }
    
    private func presentAlert() -> Alert {
        switch activeAlert {
        case .first:
            return Alert(title: Text(Constants.saveAlertTitle), message: Text(Constants.saveAlertMessage), primaryButton: .default(Text("JPG")) {
                self.saveToGallery()
            }, secondaryButton: .default(Text("PNG")) {
                self.saveAsPNG()
            })
        case .second:
            return Alert(title: Text(Constants.imageSavedTitle),message: Text(Constants.imageSavedMessage),dismissButton: .default(Text("OK")) {
                self.activeAlert = .first
            })
        }
    }
    
    fileprivate func saveToGallery() {
        self.uiimage = (UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: self.rect1))!
        let imageSaver:ImageSaver = ImageSaver(saveCompleteAlert: self.$saveAlert, activeAlert: self.$activeAlert)
        imageSaver.writeToPhotoAlbum(image: uiimage!)
    }
    
    fileprivate func saveAsPNG() {
        self.uiimage = (UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: self.rect1))!
        let imageSaver:ImageSaver = ImageSaver(saveCompleteAlert: self.$saveAlert, activeAlert: self.$activeAlert)
        imageSaver.saveAsPNG(image: uiimage!)
    }
}

struct RectGetter: View {
    @Binding var rect: CGRect
    
    var body: some View {
        GeometryReader { proxy in
            self.createView(proxy: proxy)
        }
    }
    
    func createView(proxy: GeometryProxy) -> some View {
        DispatchQueue.main.async {
            self.rect = proxy.frame(in: .global)
        }
        return Rectangle().fill(Color.clear)
    }
}

extension UIView {
    ///Save
    func asImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

