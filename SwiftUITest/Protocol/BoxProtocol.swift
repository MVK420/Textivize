//
//  BoxProtocol.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 10/1/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

protocol Box:Identifiable, Equatable {
    
    var id:UUID {get set}
    var rotateState:Double {get set}
    var offset:CGSize {get set}
    var position:CGSize {get set}
    
}

///Drag and Rotate functions
extension Box {
    
    ///Used on rotate
    mutating func setRotateState(degrees:Double) {
        self.rotateState = degrees
    }
    
    ///Used on dragging textbox
    mutating func addToPosition(translation:CGSize) {
        self.offset = CGSize(width: self.offset.width + translation.width, height: self.offset.height + translation.height)
    }
    
    ///Used on dragging textbox
    func addToPositionReturn(translation: CGSize) -> CGSize{
        let aux = CGSize(width: self.offset.width + translation.width, height: self.offset.height + translation.height)
        return aux
    }
    
    ///Used on dragging textbox
    mutating func appendToPosition(translation:CGSize) {
        self.position = CGSize(width: self.position.width + translation.width, height: self.position.height + translation.height)
    }
    
    ///Used on dragging textbox
    func combineCGSize(cg1:CGSize, cg2:CGSize) -> CGSize {
        return CGSize(width: cg1.width + cg2.width, height: cg1.height + cg2.height)
    }
    
    ///Function to figure out middle of view, to make rotation work
    ///Not Working yet
    func rotationAnchor() -> UnitPoint {
        return UnitPoint(x: self.offset.width, y: self.offset.height)
    }
    
}
