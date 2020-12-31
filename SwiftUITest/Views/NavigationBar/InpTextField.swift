//
//  InpTextField.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 12/31/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct InpTextFieldView: View {
    
    ///Input Text Field value
    @State var inputText:String = "Nothing lasts forever"
    @ObservedObject var container:ContainerMVVM
    
    var body: some View {
        TextField("Text", text: $inputText, onEditingChanged: { (changed) in
            ///When editing is happening, do nothing
            print("Editing")
        }) {
            ///When editing is finished, call func to insert text into a textbox
            self.container.text.append(TextBoxViewModel(text: self.inputText))
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

