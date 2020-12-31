//
//  InputTextFieldView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 11/14/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct inputTextFieldView: View {
    
    ///Input Text Field value
    @State var inputText:String = "Nothing lasts forever"
    @ObservedObject var containers:Container
    
    var body: some View {
        TextField("Text", text: $inputText, onEditingChanged: { (changed) in
            ///When editing is happening, do nothing
            print("Editing")
        }) {
            ///When editing is finished, call func to insert text into a textbox
            var tBox = TextBox(text: self.inputText)
            self.containers.ls.append(tBox)
            ///Empty Text Field
            self.inputText = ""//Trump For President 2020"
        }
        .font(.body)
        .foregroundColor(Color.orange)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        //.fixedSize()
        .frame(width:200,alignment:.leading)
    }
}
