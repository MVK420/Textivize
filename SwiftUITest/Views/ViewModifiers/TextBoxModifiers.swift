//
//  TextBoxModifiers.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 10/2/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct DragModifierTextBox: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    @GestureState var position:CGSize
    @Binding var selectedGesture: TextBox?
    @Binding var selectedCustomizeIndex:Int?
    
    func body(content: Content) -> some View {
        content
            .offset(self.selectedGesture == self.containers.ls[i] ? self.position : self.containers.ls[i].position).scaledToFit()
            .gesture(DragGesture(minimumDistance: 10)
                        .updating(self.$position, body: { (value, state, translation) in
                            if nil == self.selectedGesture {
                                self.selectedGesture = self.containers.ls[i]
                            } else {
                                if self.selectedCustomizeIndex == i {
                                    self.containers.ls[i].alignmentForTextBox(swipeVal: value.translation)
                                } else {
                                    let aux = self.containers.ls[i].position
                                    let res = CGSize(width: aux.width + value.translation.width, height: aux.height + value.translation.height)
                                    state = res
                                }
                            }
                        })
                        .onEnded() { value in
                            if self.selectedGesture == self.containers.ls[i] {
                                if self.selectedCustomizeIndex == i {
                                    //self.containers.ls[i].alignmentForTextBox(swipeVal: value.translation)
                                } else {
                                    self.containers.ls[i].appendToPosition(translation: value.translation)
                                }
                            }
                            self.selectedGesture = nil
                            //self.containers.ls[i].addToPosition(translation: value.translation)
                        }
                     
            )
    }
}
 
struct RotationModifierTextBox: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: self.containers.ls[i].rotateState),anchor: self.containers.ls[i].rotationAnchor())
            .gesture(RotationGesture()
                        .onChanged { value in
                            self.containers.ls[i].rotateState = value.degrees
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
}

