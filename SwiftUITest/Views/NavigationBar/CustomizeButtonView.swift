//
//  CustomizeButtonView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 11/14/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct CustomizeButtonView: View {
    
    @Binding var displayEditList:Bool
    
    var body: some View {
        Button(action: {self.displayEditList = !self.displayEditList}) {
            Image(systemName: "scope")
        }
        .frame(width: 25.0, height: 25.0)
        .cornerRadius(8)
    }
}
