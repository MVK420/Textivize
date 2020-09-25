//
//  KerningButton.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/25/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct KerningButton: View {
    
    @Binding var displayKerningBox:Bool
    
    var body: some View {
        Button(action: {self.displayKerningBox = !self.displayKerningBox}) {
            Image(systemName: "k.circle.fill")
        }.padding(.all)
    }
    
    init(displayKerningBox:Binding<Bool>) {
        self._displayKerningBox = displayKerningBox
    }
}

struct KerningSelectBox:View {
    
    @Binding var selectedCustomizeIndex:Int?
    @ObservedObject var containers:Container
    
    var body: some View {
        VStack(){
            Text("Kerning")
                .font(.custom("Helvetica", size: 30))
            HStack() {
                Button(action: {}) {
                    Text("+").font(.custom("Helvetica", size: 30))
                }
                Text("12").font(.custom("Helvetica", size: 30))
                Button(action: {}) {
                    Text("-").font(.custom("Helvetica", size: 30))
                }
            }
        }.border(Color.orange, width: 2)
    }
    
    init(containers:ObservedObject<Container>, selected:Binding<Int?>) {
        self._containers = containers
        self._selectedCustomizeIndex = selected
    }
}

/*
 struct KerningButton_Previews: PreviewProvider {
 static var previews: some View {
 KerningButton()
 }
 }
 */
