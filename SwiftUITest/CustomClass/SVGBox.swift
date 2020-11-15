//
//  SVGBox.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 11/15/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI
import SVGKit

struct SVGBox:Box {

    var id = UUID()
    var img:SVGKImage
    var rotateState: Double = 0
    var offset = CGSize.zero
    var position = CGSize.zero
    var scale:CGFloat = 1.0
    var toDelete: Bool = false
}
