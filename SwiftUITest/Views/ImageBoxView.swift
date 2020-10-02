//
//  ImageBoxView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 10/2/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct ImageBoxView: View {
    
    @ObservedObject var containers:Container
    @Binding var selectedCustomizeImageIndex:Int?
    @Binding var selectedImageGesture:ImageBox?
    @GestureState var position:CGSize = CGSize.zero
    
    var body: some View {
        Group {
            ForEach(self.containers.images.indices, id: \.self) { i in
                VStack() {
                    Image(uiImage: self.containers.images[i].img)
                        .resizable()
                        .scaleEffect(self.containers.images[i].scale)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 100, maxHeight: 100)
                        .rotationEffect(Angle(degrees: self.containers.images[i].rotateState),anchor: self.containers.images[i].rotationAnchor())
                        .DragImage(i: i, containers: self.containers, position: self.position, selectedImageGesture: self.$selectedImageGesture)
                        .if(self.selectedCustomizeImageIndex == i ? true : false) {$0.RotationImage(i: i, containers: self.containers)}
                        .if(self.selectedCustomizeImageIndex == nil ? true : false) {$0.MagnifyImage(i:i, containers:self.containers)}
                        .onTapGesture(perform: {
                                self.selectedCustomizeImageIndex = i
                        })
                }
            }
        }
    }
    
    init(containers:ObservedObject<Container>, selectedCustomizeImageIndex:Binding<Int?>,selectedImageGesture:Binding<ImageBox?>) {
        self._containers = containers
        self._selectedCustomizeImageIndex = selectedCustomizeImageIndex
        self._selectedImageGesture = selectedImageGesture
    }
    
}
