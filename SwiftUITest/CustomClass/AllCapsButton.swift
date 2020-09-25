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
    
    var body: some View {
        Button(action: {self.containers.ls[self.selectedCustomizeIndex!].allCaps()}) {
            Image(systemName: "textformat.size")
        }
    }
    
    init(containers:ObservedObject<Container>, selected:Binding<Int?>) {
        self._containers = containers
        self._selectedCustomizeIndex = selected
    }
}

/*
struct AllCapsButton_Previews: PreviewProvider {
    static var previews: some View {
        AllCapsButton(selectedCustomizeIndex: <#Binding<Int?>#>)
    }
}
*/
