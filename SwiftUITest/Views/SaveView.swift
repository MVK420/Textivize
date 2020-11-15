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
