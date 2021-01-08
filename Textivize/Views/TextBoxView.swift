//
//  TextBoxView.swift
//  Textivize
//
//  Created by Mozes Vidami on 10/2/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

///Builds the VStack that contains the words one above the other
struct TextBoxView: View {
    
    @ObservedObject var containers:Container
    @Binding var selectedCustomizeIndex:Int?
    @Binding var selectedGesture:TextBox?
    @GestureState var position:CGSize = CGSize.zero
    ///List of fonts in system
    private let fontList = UIFont.familyNames
    
    ///CIRCLESTUFF
    @State var textSizes: [Int:Double] = [:]
    
    private func returnCircle(index:Int) -> some View {
        return ZStack {
            ForEach(  self.containers.ls[index].texts, id: \.self.offset) { (offset, element) in
                VStack {
                    Text(String(element))
                        .kerning(self.containers.ls[index].kerning)
                        .foregroundColor(self.containers.ls[index].words[0].fontColor)
                        .background(Sizeable())
                        .font(.custom(self.containers.ls[index].words[0].fontStyle, size: self.containers.ls[index].words[0].fontSize))
                        .font(.custom(self.fontList[index], size: 40))
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                            self.textSizes[offset] = Double(size)
                        })
                    Spacer()
                }
                .onTapGesture {
                    self.selectedCustomizeIndex = index
                }
                .rotationEffect(self.angle(at: offset, radius: self.containers.ls[index].radius))
                
            }
        }.rotationEffect(-self.angle(at: self.containers.ls[index].texts.count-1, radius: self.containers.ls[index].radius)/2)
        .frame(width: 300, height: 300, alignment: .center)
    }
    
    private func angle(at index: Int, radius:Double) -> Angle {
        guard let labelSize = textSizes[index] else {return .radians(0)}
        let percentOfLabelInCircle = labelSize / radius.perimeter
        let labelAngle = 2 * Double.pi * percentOfLabelInCircle
        let totalSizeOfPreChars = textSizes.filter{$0.key < index}.map{$0.value}.reduce(0,+)
        let percenOfPreCharInCircle = totalSizeOfPreChars / radius.perimeter
        let angleForPreChars = 2 * Double.pi * percenOfPreCharInCircle
        return .radians(angleForPreChars + labelAngle)
    }
    ///ENDOFCIRCLESTUFF
    
    var body: some View {
        Group{
            ///Loop through each word in textbox.words
            ForEach(self.containers.ls.indices, id: \.self) { i in
                ///Create a VStack with alignemnt and leading of TextBox
                VStack (alignment: self.containers.ls[i].alignment, spacing: self.containers.ls[i].spacingForTextBox()){
                    ///If it's a circleBool is true, display it as a Circle
                    if self.containers.ls[i].circleBool == true{
                        returnCircle(index: i)
                    } else {
                        ForEach(self.containers.ls[i].words.indices, id: \.self) { j in
                            ///Create a Text for each word
                            ///setup font, color, onTap Border around VStack
                            Text(self.containers.ls[i].words[j].text)
                                .kerning(self.containers.ls[i].kerningForTextBox())
                                .font(.custom(self.containers.ls[i].words[j].fontStyle, size: self.containers.ls[i].words[j].fontSize))
                                .minimumScaleFactor(self.containers.ls[i].scaleFactorForTextBox())
                                .lineLimit(1)
                                .foregroundColor(self.containers.ls[i].words[j].fontColor)
                                //.sheet(isPresented: self.$detailPresented) { DetailView(detailPresented: self.$detailPresented) }
                                .onTapGesture {
                                    ///Remove this eventually
                                    //self.detailPresented = true
                                    self.selectedCustomizeIndex = i
                                }
                        }
                    }
                }
                .frame(width: self.containers.ls[i].widthForTextBox())
                //.fixedSize(horizontal:false, vertical: true)
                .border(self.selectedCustomizeIndex == i ? Color.black : Color.clear)
                .scaleEffect(self.containers.ls[i].scale)
                .isHidden(!self.containers.ls[i].toDelete)
                ///Simultaneous Gestures for moving on drag, Rotate and Magnify on pinch
                .DragText(i: i, containers: self.containers, position: self.containers.ls[i].position, selectedGesture: self.$selectedGesture, selectedCustomizeIndex: self.$selectedCustomizeIndex)
                .RotationText(i: i, containers: self.containers)
                .MagnifyText(i: i, containers: self.containers)
                //.zIndex(self.containers.ls[i].zIndex)
            }
        }
    }
}
