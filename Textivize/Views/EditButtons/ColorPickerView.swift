//
//  ColorPickerView.swift
//  Textivize
//
//  Created by Mozes Vidami on 11/14/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct ColorPickerView: View {
    
    @Binding var selectedColor:Color
    @Binding var backgroundColor:Color
    var selectedCustomizeIndex:Int?
    @ObservedObject var containers:Container
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ColorPicker("", selection: self.$selectedColor)
                .frame(height: 200)
                .onChange(of: self.selectedColor, perform: { value in
                    self.onChangeColorPicker()
                })
                .frame(width: 5.0, height: 5.0)
                .padding(.all)
                .font(.title)
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func onChangeColorPicker() {
        if self.selectedCustomizeIndex != nil {
            self.containers.txt[selectedCustomizeIndex!].selectedFontColor = self.selectedColor
            self.containers.txt[selectedCustomizeIndex!].setAllWordColor()
        } else {
            self.backgroundColor = self.selectedColor
        }
    }
}

