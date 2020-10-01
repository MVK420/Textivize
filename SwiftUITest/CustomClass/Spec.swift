//
//  KerningButton.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/25/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct SpecButton: View {
    
    @Binding var displayBox:Bool
    @Binding var selectedCustomizeIndex:Int?
    @ObservedObject var containers:Container
    var caseBox:String
    
    var body: some View {
        Button(action: {
            if self.selectedCustomizeIndex != nil {
                self.displayBox = !self.displayBox
                //let font:CGFloat =  self.containers.ls[self.selectedCustomizeIndex!].fontForTextBox()
                //self.containers.ls[self.selectedCustomizeIndex!].setAllFontsSize(font: font)
                self.activateCaseBool()
            }
        }) {
            Image(systemName: self.findImage())
        }.padding(.all)
        .font(.title)
    }
    
    init(displayBox:Binding<Bool>,containers:ObservedObject<Container>, selected:Binding<Int?>,caseBox: String) {
        self._displayBox = displayBox
        self._containers = containers
        self._selectedCustomizeIndex = selected
        self.caseBox = caseBox
    }
    
    private func activateCaseBool() {
        switch self.caseBox {
        case "Kerning":
            self.containers.ls[self.selectedCustomizeIndex!].kerningBool = true
        case "Radius":
            self.containers.ls[self.selectedCustomizeIndex!].radiusBool = true
        case "Spacing":
            self.containers.ls[self.selectedCustomizeIndex!].spacingBool = true
        default:
            return
        }
    }
    
    ///Find the Image for the Button
    private func findImage() -> String {
        switch self.caseBox {
        case "Kerning":
            return "k.circle.fill"
        case "Radius":
            return "r.circle.fill"
        case "Spacing":
            return "s.circle.fill"
        default:
            return ""
        }
    }
}

struct SpecSelectBox:View {
    
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
                        self.containers.ls[self.selectedCustomizeIndex!].addToCase(caseBox: self.caseBox, val: 1)
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
                            if self.selectedCustomizeIndex != nil {
                                self.containers.ls[self.selectedCustomizeIndex!].addToCase(caseBox: self.caseBox, val: -1)
                            }
                        }}) {
                    Text("-").font(.custom("Helvetica", size: 30))
                }
            }
            .background(Color.secondary)
        }.border(Color.orange, width: 2)
        .background(Color.secondary)
        .padding(.bottom)
    }
    
    
    init(containers:ObservedObject<Container>, selected:Binding<Int?>, caseBox:String) {
        self._containers = containers
        self._selectedCustomizeIndex = selected
        self.caseBox = caseBox
    }
}
