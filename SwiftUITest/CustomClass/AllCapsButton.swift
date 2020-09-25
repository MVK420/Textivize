//
//  AllCapsButton.swift
//  SwiftUITest
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
        Button(action: {if self.allCaps == true {
            self.containers.ls[self.selectedCustomizeIndex!].allCaps()
        } else {
            self.containers.ls[self.selectedCustomizeIndex!].capitalize()
        }
        
        })
        {
            Image(systemName: self.allCaps == true ?"textformat.size" : "arrowtriangle.up.square.fill")
        }
        .padding(.all)
    }
    
    init(containers:ObservedObject<Container>, selected:Binding<Int?>,allCaps:Bool) {
        self._containers = containers
        self._selectedCustomizeIndex = selected
        self.allCaps = allCaps
    }
}

/*
 struct AllCapsButton_Previews: PreviewProvider {
 static var previews: some View {
 AllCapsButton(selectedCustomizeIndex: <#Binding<Int?>#>)
 }
 }
 */
