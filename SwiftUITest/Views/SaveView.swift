//
//  SaveView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 11/15/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct SaveButton: View {
    
    @State var saveAlert:Bool = false
    @State var uiimage:UIImage? = nil
    @Binding var rect1: CGRect
    
    var body: some View {
        Button(action: { self.uiimage = (UIApplication.shared.windows[0].rootViewController?.view.asImage(rect: self.rect1))!
            let imageSaver:ImageSaver = ImageSaver(saveAlert: self.$saveAlert)
            imageSaver.writeToPhotoAlbum(image: uiimage!)
        }) {
            Text("Save")
        }.alert(isPresented: self.$saveAlert) {
            Alert(title: Text("Message"),message: Text("Photo saved successfully"),dismissButton: .default(Text("OK")))
        }
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
    
    @Binding var saveAlert:Bool

    init(saveAlert:Binding<Bool>) {
        self._saveAlert = saveAlert
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        saveAlert.toggle()
    }
}

