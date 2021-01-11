//
//  CircleButtonView.swift
//  Textivize
//
//  Created by Mozes Vidami on 11/14/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct CircleButtonView: View {
    
    @ObservedObject var containers:Container
    var selectedCustomizeIndex:Int?
    @Binding var displayRadiusBox:Bool
    @Binding var displayKerningBox:Bool
    
    var body: some View {
        Button(action: {self.onTapCircleButton()}) {
            Image(systemName: "circle")
        }
        .padding(.all)
        .font(.title)
    }
    
    private func onTapCircleButton() {
        if self.selectedCustomizeIndex != nil {
            self.containers.txt[self.selectedCustomizeIndex!].sameWidth = false
            let font:CGFloat =  self.containers.txt[self.selectedCustomizeIndex!].fontForTextBox()
            self.containers.txt[self.selectedCustomizeIndex!].setAllFontsSize(font: font)
            self.containers.txt[self.selectedCustomizeIndex!].grState = 0
            self.containers.txt[self.selectedCustomizeIndex!].circleBool = !self.containers.txt[self.selectedCustomizeIndex!].circleBool
            self.displayRadiusBox = self.containers.txt[self.selectedCustomizeIndex!].circleBool
            self.displayKerningBox = self.containers.txt[self.selectedCustomizeIndex!].circleBool
        }
    }
}
