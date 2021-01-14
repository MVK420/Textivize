//
//  CustomizeButtonView.swift
//  Textivize
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
            Text("Customize")
        }
        .frame(width: 50.0, height: 50.0)
        .cornerRadius(8)
    }
}
