//
//  Word.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/7/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct Word:Hashable {
    
    var id = UUID()
    var text:String
    var ogText:String
    var fontSize:CGFloat
    var fontColor:Color = .black
    var fontStyle:String = "Papyrus"

}
