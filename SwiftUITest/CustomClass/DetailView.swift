//
//  DetailView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/9/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @Binding var detailPresented: Bool
    //@Binding var textBox:TextBox
    
    fileprivate func VStackTextBox() -> some View {
        return VStack{
            ///Loop through each word in textbox.words
            Text("ALMAFA")
            /*
            ForEach(textBox.words.indices, id: \.self) { i in
                ///Create a Text for each word
                ///setup font, color, onClick to Detail,
                Text(self.textBox.words[i].text)
                    .font(.system(size: self.textBox.words[i].fontSize))
                    .foregroundColor(self.textBox.words[i].fontColor)
            }
 */
        }
    }
    
    
    var body: some View {
        Text("ALMAFA")
    }
}

