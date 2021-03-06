//
//  SameWidthButtonView.swift
//  Textivize
//
//  Created by Mozes Vidami on 11/14/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct SameWidthButtonView: View {
    
    @ObservedObject var containers:Container
    var selectedCustomizeIndex:Int?
    
    var body: some View {
        Button(action: {self.onTapWidthButton()}, label: {
            Image(systemName: "w.circle.fill")
        })
        .font(.title)
        .isHidden(!self.selectedAndCircle(containers: self.containers, selectedCustomizeIndex: self.selectedCustomizeIndex))
    }
    
    private func onTapWidthButton() {
        ///If there's a Textbox that is selected to customize
        if self.selectedCustomizeIndex != nil {
            ///Set other bools to false
            self.containers.txt[self.selectedCustomizeIndex!].circleBool = false
            self.containers.txt[self.selectedCustomizeIndex!].grState = 0
            ///SameWidth = !SameWidth
            self.containers.txt[self.selectedCustomizeIndex!].sameWidth = !self.containers.txt[self.selectedCustomizeIndex!].sameWidth
            ///Get font size (standard for textbox if sameWidth = false, 160 if true, that will be scaled down)
            let font:CGFloat =  self.containers.txt[self.selectedCustomizeIndex!].fontForTextBox()
            self.containers.txt[self.selectedCustomizeIndex!].setAllFontsSize(font: font)
        }
    }
}
