//
//  ImageBox.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 10/1/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct ImageBox:Box, Identifiable, Equatable {

    var id = UUID()
    var img:UIImage
    var rotateState: Double = 0
    var offset = CGSize.zero
    var position = CGSize.zero
    
}
