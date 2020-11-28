//
//  TextBoxModifiers.swift
//  SwiftUITest
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
            .offset(self.selectedGesture == self.containers.ls[i] && self.selectedCustomizeIndex != i ? self.position : self.containers.ls[i].position).scaledToFit()
            .simultaneousGesture(DragGesture(minimumDistance: 10)
                                    .updating(self.$position, body: { (value, state, translation) in
                                        self.selectedGesture = self.containers.ls[i]
                                        if self.selectedCustomizeIndex == i {
                                        } else {
                                            let aux = self.containers.ls[i].position
                                            let res = CGSize(width: aux.width + value.translation.width, height: aux.height + value.translation.height)
                                            ///Delete
                                            if res.width > -20 && res.width < 20 && res.height > 350 {
                                                self.containers.ls[i].toDelete = true
                                                self.selectedGesture = nil
                                            }
                                            state = res
                                        }
                                    })
                                    .onEnded() { value in
                                        if self.selectedGesture == self.containers.ls[i] {
                                            if self.selectedCustomizeIndex == i {
                                                self.containers.ls[i].alignmentForTextBox(swipeVal: value.translation)
                                            } else {
                                                self.containers.ls[i].appendToPosition(translation: value.translation)
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
                self.containers.ls[i].scale = self.containers.ls[i].scale * delta
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
            .rotationEffect(Angle(degrees: self.containers.ls[i].rotateState),anchor: self.containers.ls[i].rotationAnchor())
            .simultaneousGesture(RotationGesture()
                                    .onChanged { value in
                                        self.containers.ls[i].pinRotate(degrees: value.degrees)
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

