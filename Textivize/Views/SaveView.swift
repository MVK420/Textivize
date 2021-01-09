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
    @State var uiimage:UIImage? = nil
    @Binding var rect1: CGRect
    @State var text = "Save"
    @State private var activeAlert: ActiveAlert = .first
    
    var body: some View {
        Button(action: {self.onTapSaveButton()}) {
            Text("Save")
        }.alert(isPresented: self.$saveAlert) {
            self.presentAlert()
        }.onReceive(NotificationCenter.default.publisher(for: NSNotification.canSaveImage)) { _ in
            self.onDismissedAd()}
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
        //self.playInterstitialAd()
        //self.parentFunction?()
        //self.saveAlert = true
    }
    
    private func presentAlert() -> Alert {
        switch activeAlert {
        case .first:
            return Alert(title: Text("Are you sure you want to save this?"), message: Text(""), primaryButton: .default(Text("Save")) {
                print("Saving...")
                self.saveToGallery()
            }, secondaryButton: .cancel())
        case .second:
            return Alert(title: Text("Message"),message: Text("Photo saved successfully"),dismissButton: .default(Text("OK")) {
                self.activeAlert = .first
            })
        }
    }
    
    fileprivate func saveToGallery() {
        self.uiimage = (UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: self.rect1))!
        let imageSaver:ImageSaver = ImageSaver(saveCompleteAlert: self.$saveAlert, activeAlert: self.$activeAlert)
        //imageSaver.writeToPhotoAlbum(image: uiimage!)
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

class ImageSaver: NSObject {
    
    @Binding var saveCompleteAlert:Bool
    @Binding var activeAlert:ActiveAlert
    
    init(saveCompleteAlert:Binding<Bool>,activeAlert:Binding<ActiveAlert>) {
        self._saveCompleteAlert = saveCompleteAlert
        self._activeAlert = activeAlert
    }
    
    func saveAsPNG(image:UIImage) {
        if let data = image.pngData() {
            print(data)
            let filename = getDocumentsDirectory().appendingPathComponent("textivize.png")
            _ = filename.startAccessingSecurityScopedResource()
            try? data.write(to: filename)
            filename.stopAccessingSecurityScopedResource()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        activeAlert = .second
        saveCompleteAlert.toggle()
    }
}

///For Hiding
struct ParentFunctionKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var parrentFunc: (() -> Void)? {
        get { self[ParentFunctionKey.self] }
        set { self[ParentFunctionKey.self] = newValue }
    }
}

