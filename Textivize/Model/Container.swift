//
//  Container.swift
//  Textivize
//
//  Created by Mozes Vidami on 9/12/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

class Container: ObservableObject {
    
    @Published var txt:[TextBox] = [TextBox]()
    @Published var images:[ImageBox] = [ImageBox]()
    @Published var svgs:[SVGBox] = [SVGBox]()
    
}
