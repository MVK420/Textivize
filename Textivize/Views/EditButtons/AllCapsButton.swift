//
//  AllCapsButton.swift
//  Textivize
//
//  Created by Mozes Vidami on 9/25/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct AllCapsButton: View {
    
    @Binding var selectedCustomizeIndex:Int?
    @ObservedObject var containers:Container
    var allCaps:Bool
    
    var body: some View {
        Button(action: {self.onTapAllCapsButton()})
        {
            Image(systemName: self.allCaps == true ? "textformat.size" : "arrowtriangle.up.square.fill")
        }
        .padding(.top)
        .font(.title)
    }
    
    init(containers:ObservedObject<Container>, selected:Binding<Int?>,allCaps:Bool) {
        self._containers = containers
        self._selectedCustomizeIndex = selected
        self.allCaps = allCaps
    }
    
    private func onTapAllCapsButton() {
        if self.allCaps == true && (self.selectedCustomizeIndex != nil) {
            if self.selectedCustomizeIndex != nil{
                self.containers.txt[self.selectedCustomizeIndex!].allCaps()
            } else {
                self.containers.txt[self.selectedCustomizeIndex!].capitalize()
            }
            
        }
    }
}
