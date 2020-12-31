//
//  MVVMTextView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 12/31/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct MVVMTextView: View {
    
    @Binding var textViewModel:TextBoxViewModel
    
    var body : some View {
        VStack (alignment: textViewModel.alignment, spacing: textViewModel.spacing){
            ///If it's a circleBool is true, display it as a Circle
            ForEach(textViewModel.words.indices, id: \.self) { j in
                ///Create a Text for each word
                ///setup font, color, onTap Border around VStack
                Text(textViewModel.words[j].text)
                    .kerning(textViewModel.kerning)
                    .font(.custom(textViewModel.words[j].fontStyle, size: textViewModel.fontSize))
                    .minimumScaleFactor(textViewModel.scaleFactor)
                    .lineLimit(1)
                    .foregroundColor(textViewModel.words[j].fontColor)

            }
        }
        .frame(width: textViewModel.width)
        //.fixedSize(horizontal:false, vertical: true)
//        .border(self.selectedCustomizeIndex == i ? Color.black : Color.clear)
        .scaleEffect(textViewModel.scale)
//        .isHidden(!self.containers.ls[i].toDelete)
        ///Simultaneous Gestures for moving on drag, Rotate and Magnify on pinch
        .DragTextMVVM(viewModel: $textViewModel)
//        .RotationText(i: i, containers: self.containers)
//        .MagnifyText(i: i, containers: self.containers)
    }
}
