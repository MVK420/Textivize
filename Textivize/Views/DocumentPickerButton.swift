//
//  DocumentPickerView.swift
//  Textivize
//
//  Created by Mozes Vidami on 11/9/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct DocumentPickerButton: View {
    
    @Binding var showFilePicker:Bool
    
    var body: some View {
        Button(action: {self.showFilePicker.toggle()}) {
            Image(systemName: "folder.fill")
            Text("Open Files") 
        }
        .frame(width: 50.0, height: 20)
        .padding(.top)
    }
    
    init(showFilePicker:Binding<Bool>) {
        self._showFilePicker = showFilePicker
    }
}

