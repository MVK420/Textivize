//
//  SVGBoxView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 11/15/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI
import SVGKit

struct SVGBoxVIew: View {
    
    @ObservedObject var containers:Container
    //@Binding var selectedCustomizeSVGIndex:Int?
    //@Binding var selectedSVGGesture:ImageBox?
    //@GestureState var position:CGSize = CGSize.zero
    
    var body: some View {
        Group {
            ForEach(self.containers.svgs.indices, id: \.self) { i in
                VStack() {
                    SVGKFastImageViewSUI(SVGImage: self.containers.svgs[i].img)
                        .frame(width: 25, height: 25)
                }
            }
        }
    }
}

struct SVGKFastImageViewSUI:UIViewRepresentable {
    
    var SVGImage: SVGKImage
    
    func makeUIView(context: Context) -> SVGKFastImageView {
        return SVGKFastImageView(svgkImage: SVGImage ?? SVGKImage())
        
    }
    
    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
        
    }
}
