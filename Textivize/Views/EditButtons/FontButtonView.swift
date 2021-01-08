//
//  FontButtonView.swift
//  Textivize
//
//  Created by Mozes Vidami on 11/14/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct FontButtonView: View {
    
    @Binding var fontPresented:Bool
    
    var body: some View {
        Button(action: {
            self.fontPresented = !self.fontPresented
        }) {
            Image(systemName: "f.circle.fill")
        }
        .padding(.all)
        .font(.title)
    }
}
