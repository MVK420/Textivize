//
//  ImageBoxModifiers.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 10/2/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct RotationModifierImage: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    
    func body(content: Content) -> some View {
        content
            .gesture(RotationGesture()
                        .onChanged { value in
                            self.containers.images[i].rotateState = value.degrees
                            self.containers.objectWillChange.send()
                        })
    }
}

struct MaginificationModifierImage: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    @State var lastScaleValue: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .gesture(MagnificationGesture().onChanged { val in
                let delta = val / self.lastScaleValue
                self.lastScaleValue = val
                self.containers.images[i].scale = self.containers.images[i].scale * delta
                
                //... anything else e.g. clamping the newScale
            }.onEnded { val in
                // without this the next gesture will be broken
                self.lastScaleValue = 1.0
            })
    }
}

struct DragModifierImage: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    @GestureState var position:CGSize
    @Binding var selectedImageGesture: ImageBox?
    
    func body(content: Content) -> some View {
        content
            .offset(self.selectedImageGesture == self.containers.images[i] ? self.position : self.containers.images[i].position).scaledToFit()
            .gesture(DragGesture(minimumDistance: 1)
                        .updating(self.$position, body: { (value, state, translation) in
                            self.selectedImageGesture = self.containers.images[i]
                            let aux = self.containers.images[i].position
                            let res = CGSize(width: aux.width + value.translation.width, height: aux.height + value.translation.height)
                            state = res
                        })
                        .onEnded() { value in
                            if self.selectedImageGesture == self.containers.images[i] {
                                self.containers.images[i].appendToPosition(translation: value.translation)
                            }
                            self.selectedImageGesture = nil
                            //self.containers.ls[i].addToPosition(translation: value.translation)
                        }
            )
    }
}

extension View {
    
    func RotationImage(i:Int, containers:Container) -> some View {
        self.modifier(RotationModifierImage(i: i, containers: containers))
    }
    
    func DragImage(i:Int, containers:Container, position:CGSize, selectedImageGesture:Binding<ImageBox?>) -> some View{
        self.modifier(DragModifierImage(i: i, containers: containers, position: position, selectedImageGesture: selectedImageGesture))
    }
    
    func MagnifyImage(i:Int, containers:Container) -> some View {
        self.modifier(MaginificationModifierImage(i: i, containers: containers))
    }
}
