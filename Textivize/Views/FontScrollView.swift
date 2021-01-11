//
//  FontScrollView.swift
//  Textivize
//
//  Created by Mozes Vidami on 11/14/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct FontScrollView: View {

    @ObservedObject var containers:Container
    ///List of fonts in system
    private let fontList = UIFont.familyNames
    @Binding var selectedFont:Int
    @Binding var fontPresented:Bool
    var selectedCustomizeIndex:Int?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack() {
                ForEach(fontList.indices, id: \.self) { i in
                    Text("\(self.fontList[i])")
                        .font(.custom(self.fontList[i], size: 20))
                        .foregroundColor(self.selectedFont == i ? .red : .black)
                        .lineLimit(nil)
                        .frame(width: 500, height: 20)
                        .gesture(TapGesture()
                                    .onEnded({self.tapGestureEnded(i)}
                                    ))
                }
            }
        }
        .frame(width: 250, height: 220)
        .isHidden(self.fontPresented)
        .background(Color.clear)
        .border(Color.orange, width: 4)
        .cornerRadius(7)
        .clipShape(Rectangle())
    }
    
    private func tapGestureEnded(_ i:Int) {
        if self.selectedCustomizeIndex != nil {
            self.containers.txt[self.selectedCustomizeIndex!].setAllFonts(font: self.fontList[i])
        }
        self.selectedFont = i
    }
}
