//
//  Container.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/12/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

class Container: ObservableObject {
    
    @Published var ls:[TextBox] = [TextBox]()
    @Published var images:[ImageBox] = [ImageBox]()
    @Published var svgs:[SVGBox] = [SVGBox]()
    
}

class ContainerMVVM: ObservableObject {
    
    @Published var text:[TextBoxViewModel] = [TextBoxViewModel]()
    //@Published var images:[ImageBox] = [ImageBox]()
    //@Published var svgs:[SVGBox] = [SVGBox]()
    
}
