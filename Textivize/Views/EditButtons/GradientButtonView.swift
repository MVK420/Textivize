//
//  GradientButtonView.swift
//  Textivize
//
//  Created by Mozes Vidami on 11/14/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct GradientButtonView: View {
    
    @ObservedObject var containers:Container
    var selectedCustomizeIndex:Int?
    @Binding var minMaxGradientPresented:Bool
    
    var body: some View {
        Button(action: {self.onTapGradientButton()})
        {
            Image(systemName: "g.circle.fill")
        }
        .padding(.top)
        .font(.title)
        .isHidden(!self.selectedAndCircle(containers: containers, selectedCustomizeIndex: self.selectedCustomizeIndex))
        
    }
    
    private func onTapGradientButton() {
        if self.selectedCustomizeIndex != nil {
            if self.containers.txt[self.selectedCustomizeIndex!].grState < 2 {
                self.minMaxGradientPresented = true//!self.minMaxGradientPresented
            } else {
                self.minMaxGradientPresented = false
            }
            self.containers.txt[self.selectedCustomizeIndex!].sameWidth = false
            self.containers.txt[self.selectedCustomizeIndex!].circleBool = false
            self.containers.txt[self.selectedCustomizeIndex!].calcFont()
        }
    }
}
