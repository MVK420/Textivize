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
    @Binding var selectedCustomizeIndex:Int?
    @ObservedObject var containers:Container
    
    var body: some View {
        Button(action: {
            if self.selectedCustomizeIndex != nil {
                self.displayKerningBox = !self.displayKerningBox
                self.containers.ls[self.selectedCustomizeIndex!].sameWidth = false
                self.containers.ls[self.selectedCustomizeIndex!].kerningBool = true
            }
        }) {
            Image(systemName: "k.circle.fill")
        }.padding(.all)
        .font(.title)
    }
    
    init(displayKerningBox:Binding<Bool>,containers:ObservedObject<Container>, selected:Binding<Int?>) {
        self._displayKerningBox = displayKerningBox
        self._containers = containers
        self._selectedCustomizeIndex = selected
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
                Button(action: {self.containers.ls[self.selectedCustomizeIndex!].addToKerning(val: 1)}) {
                    Text("+").font(.custom("Helvetica", size: 30))
                }
                Text(self.containers.ls[self.selectedCustomizeIndex!].getKerningString()
                ).font(.custom("Helvetica", size: 30))
                    
                    
                Button(action: {self.containers.ls[self.selectedCustomizeIndex!].addToKerning(val: -1)}) {
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
