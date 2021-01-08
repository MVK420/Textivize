//
//  SVGBoxView.swift
//  Textivize
//
//  Created by Mozes Vidami on 11/15/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI
import SVGKit

struct SVGBoxVIew: View {
    
    @ObservedObject var containers:Container
    @Binding var selectedCustomizeSVGIndex:Int?
    @Binding var selectedSVGGesture:SVGBox?
    @GestureState var position:CGSize = CGSize.zero
    
    var body: some View {
        Group {
            ForEach(self.containers.svgs.indices, id: \.self) { i in
                VStack() {
                    SVGKFastImageViewSUI(SVGImage: self.containers.svgs[i].img)
                        .scaleEffect(self.containers.svgs[i].scale)
                        .frame(maxWidth: 100, maxHeight: 100)
                        .rotationEffect(Angle(degrees: self.containers.svgs[i].rotateState),anchor: self.containers.svgs[i].rotationAnchor())
                        .isHidden(!self.containers.svgs[i].toDelete)
                        .DragSVG(i: i, containers: self.containers, position: CGSize.zero, selectedSVGGesture: self.$selectedSVGGesture)
                        .RotationSVG(i: i, containers: self.containers)
                        .MagnifySVG(i:i, containers:self.containers)
                }
            }
        }
    }
}

struct SVGKFastImageViewSUI:UIViewRepresentable {
    
    var SVGImage: SVGKImage
    
    func makeUIView(context: Context) -> SVGKFastImageView {
        return SVGKFastImageView(svgkImage: SVGImage)
        
    }
    
    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
        
    }
}
