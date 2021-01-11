//
//  TextBoxModifiers.swift
//  Textivize
//
//  Created by Mozes Vidami on 10/2/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

///This applied to text, will make dragging possible
struct DragModifierTextBox: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    @GestureState var position:CGSize
    @Binding var selectedGesture: TextBox?
    @Binding var selectedCustomizeIndex:Int?
    
    func body(content: Content) -> some View {
        content
            .offset(self.selectedGesture == self.containers.txt[i] && self.selectedCustomizeIndex != i ? self.position : self.containers.txt[i].position).scaledToFit()
            .simultaneousGesture(DragGesture(minimumDistance: 10)
                                    .updating(self.$position, body: { (value, state, translation) in
                                        self.selectedGesture = self.containers.txt[i]
                                        if self.selectedCustomizeIndex == i {
                                        } else {
                                            let aux = self.containers.txt[i].position
                                            let res = CGSize(width: aux.width + value.translation.width, height: aux.height + value.translation.height)
                                            print(res)
                                            ///Delete
                                            if res.width > -60 && res.width < 60 && res.height > 350 {
                                                self.containers.txt[i].toDelete = true
                                                self.selectedGesture = nil
                                            }
                                            state = res
                                        }
                                    })
                                    .onEnded() { value in
                                        if self.selectedGesture == self.containers.txt[i] {
                                            if self.selectedCustomizeIndex == i {
                                                self.containers.txt[i].alignmentForTextBox(swipeVal: value.translation)
                                            } else {
                                                self.containers.txt[i].appendToPosition(translation: value.translation)
                                            }
                                        }
                                        self.selectedGesture = nil

                                    }
                                 
            )
    }
}

///This applied to text will make magnificaiton possible
struct MaginificationModifierText: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    @State var lastScaleValue: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(MagnificationGesture().onChanged { val in
                let delta = val / self.lastScaleValue
                self.lastScaleValue = val
                self.containers.txt[i].scale = self.containers.txt[i].scale * delta
            }.onEnded { val in
                self.lastScaleValue = 1.0
            })
    }
}

///This applied to text will make rotation possible
struct RotationModifierTextBox: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: self.containers.txt[i].rotateState),anchor: self.containers.txt[i].rotationAnchor())
            .simultaneousGesture(RotationGesture()
                                    .onChanged { value in
                                        self.containers.txt[i].pinRotate(degrees: value.degrees)
                                        self.containers.objectWillChange.send()
                                    })
    }
}



extension View {
    
    func RotationText(i:Int, containers:Container) -> some View {
        self.modifier(RotationModifierTextBox(i: i, containers: containers))
    }
    
    func DragText(i:Int,containers:Container, position:CGSize,selectedGesture:Binding<TextBox?>,selectedCustomizeIndex:Binding<Int?>) -> some View{
        self.modifier(DragModifierTextBox(i: i, containers: containers, position: position, selectedGesture: selectedGesture, selectedCustomizeIndex: selectedCustomizeIndex))
    }
    
    func MagnifyText(i:Int, containers:Container) -> some View {
        self.modifier(MaginificationModifierText(i: i, containers: containers))
    }
}

