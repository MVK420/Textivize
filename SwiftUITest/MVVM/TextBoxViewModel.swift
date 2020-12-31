//
//  TextBoxViewModel.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 12/31/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct TextBoxViewModel: Identifiable {
    
    let id:UUID = UUID()
    let model:TextBox
    var words:[Word] = [Word]()
    var fontSize:CGFloat = 40
    var kerning:CGFloat = 0
    var alignment:HorizontalAlignment = .center
    var spacing:CGFloat = 0
    var scaleFactor:CGFloat = 1
    var width:CGFloat = 300
    var scale:CGFloat = 1
    var position = CGSize.zero
    
    init(text:String) {
        let model:TextBox = TextBox(text: text)
        self.words = model.words
        self.model = model
    }
    
    ///Used on dragging textbox
    mutating func appendToPosition(translation:CGSize) {
        self.position = CGSize(width: self.position.width + translation.width, height: self.position.height + translation.height)
    }
}
