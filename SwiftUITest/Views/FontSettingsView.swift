//
//  FontSettingsView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 10/5/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI
import CoreText


struct FontSettingsView: View {
    //private var font:UIFont!
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .font(Font.custom("HanziPenSC",size: 30))
        
        Button(action: self.downloadAndRegister) {
            Text("Download")
        }
    }
    
    private func registerFont() -> UIFont {
        let fontURL = Bundle.main.url(forResource: "Windsong", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        let font = UIFont(name: "PillGothic300mg-bold", size: 30)!
        return font
    }
    
    private func downloadAndRegister() {
        print("Started")
        let urlString = "http://iweslie.com/fonts/HanziPenSC-W3.ttf"
        let url = URL(string: urlString)
        let fontURLArray = [url] as CFArray
        CTFontManagerRegisterFontURLs(fontURLArray, .persistent, true) { (errors, done) -> Bool in
            if done {
                print("done")
            }
            print(errors as Array)
            return true
        }
    }
}

