//
//  SVGBoxModifiers.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 11/15/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

///This applied to Image will make Rotation possible
struct RotationModifierSVG: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(RotationGesture()
                        .onChanged { value in
                            self.containers.svgs[i].rotateState = value.degrees
                            self.containers.objectWillChange.send()
                        })
    }
}

///This applied to SVG will make magnificaiton possible
struct MaginificationModifierSVG: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    @State var lastScaleValue: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(MagnificationGesture().onChanged { val in
                let delta = val / self.lastScaleValue
                self.lastScaleValue = val
                self.containers.svgs[i].scale = self.containers.svgs[i].scale * delta
                
                //... anything else e.g. clamping the newScale
            }.onEnded { val in
                // without this the next gesture will be broken
                self.lastScaleValue = 1.0
            })
    }
}

///This applied to SVG will make dragging possible
struct DragModifierSVG: ViewModifier {
    
    var i:Int
    @ObservedObject var containers:Container
    @GestureState var position:CGSize
    @Binding var selectedSVGGesture: SVGBox?
    
    func body(content: Content) -> some View {
        content
            .offset(self.selectedSVGGesture == self.containers.svgs[i] ? self.position : self.containers.svgs[i].position).scaledToFit()
            .simultaneousGesture(DragGesture(minimumDistance: 1)
                        .updating(self.$position, body: { (value, state, translation) in
                            self.selectedSVGGesture = self.containers.svgs[i]
                            let aux = self.containers.svgs[i].position
                            let res = CGSize(width: aux.width + value.translation.width, height: aux.height + value.translation.height)
                            ///Delete
                            if res.width > -20 && res.width < 20 && res.height > 350 {
                                self.containers.svgs[i].toDelete = true
                                self.selectedSVGGesture = nil
                            }
                            state = res
                        })
                        .onEnded() { value in
                            if self.selectedSVGGesture == self.containers.svgs[i] {
                                self.containers.svgs[i].appendToPosition(translation: value.translation)
                            }
                            self.selectedSVGGesture = nil
                            //self.containers.ls[i].addToPosition(translation: value.translation)
                        }
            )
    }
}

extension View {
    
    func RotationSVG(i:Int, containers:Container) -> some View {
        self.modifier(RotationModifierSVG(i: i, containers: containers))
    }
    
    func DragSVG(i:Int, containers:Container, position:CGSize, selectedSVGGesture:Binding<SVGBox?>) -> some View{
        self.modifier(DragModifierSVG(i: i, containers: containers, position: position, selectedSVGGesture: selectedSVGGesture))
    }
    
    func MagnifySVG(i:Int, containers:Container) -> some View {
        self.modifier(MaginificationModifierSVG(i: i, containers: containers))
    }
}

