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
    var caseBox:String
    
    var body: some View {
        Button(action: {
            if self.selectedCustomizeIndex != nil {
                self.displayKerningBox = !self.displayKerningBox
                self.containers.ls[self.selectedCustomizeIndex!].sameWidth = false
                if caseBox == "Kerning" {
                    self.containers.ls[self.selectedCustomizeIndex!].kerningBool = true
                } else {
                    self.containers.ls[self.selectedCustomizeIndex!].radiusBool = true
                }
            }
        }) {
            if caseBox == "Kerning" {
                Image(systemName: "k.circle.fill")
            } else {
                Image(systemName: "r.circle.fill")
            }
        }.padding(.all)
        .font(.title)
    }
    
    init(displayKerningBox:Binding<Bool>,containers:ObservedObject<Container>, selected:Binding<Int?>,caseBox: String) {
        self._displayKerningBox = displayKerningBox
        self._containers = containers
        self._selectedCustomizeIndex = selected
        self.caseBox = caseBox
    }
}

struct KerningSelectBox:View {
    
    @Binding var selectedCustomizeIndex:Int?
    @ObservedObject var containers:Container
    var caseBox:String
    
    var body: some View {
        VStack(){
            Text(self.caseBox)
                .font(.custom("Helvetica", size: 20))
                .foregroundColor(Color.orange)
            HStack() {
                Button(action: {
                    if self.selectedCustomizeIndex != nil {
                        if self.caseBox == "Kerning" {
                            self.containers.ls[self.selectedCustomizeIndex!].addToKerning(val: 1)
                        } else {
                            self.containers.ls[self.selectedCustomizeIndex!].addToRadius(val: 1)
                        }
                    }
                }) {
                    Text("+").font(.custom("Helvetica", size: 30))
                }
                if self.selectedCustomizeIndex != nil{
                    Text(self.containers.ls[self.selectedCustomizeIndex!].getString(caseBox:self.caseBox)
                    ).font(.custom("Helvetica", size: 30))
                    .foregroundColor(Color.orange)
                }
                
                
                Button(action: {
                        if self.selectedCustomizeIndex != nil {
                            if self.caseBox == "Kerning" {
                                self.containers.ls[self.selectedCustomizeIndex!].addToKerning(val: -1)
                            } else {
                                self.containers.ls[self.selectedCustomizeIndex!].addToRadius(val: -1)
                            }
                        }}) {
                    Text("-").font(.custom("Helvetica", size: 30))
                }
            }
        }.border(Color.orange, width: 2)
    }
    
    
    init(containers:ObservedObject<Container>, selected:Binding<Int?>, caseBox:String) {
        self._containers = containers
        self._selectedCustomizeIndex = selected
        self.caseBox = caseBox
    }
}

/*
 struct KerningButton_Previews: PreviewProvider {
 static var previews: some View {
 KerningButton()
 }
 }
 */
