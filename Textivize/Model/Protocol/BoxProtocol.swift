//
//  BoxProtocol.swift
//  Textivize
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
    var scale:CGFloat {get set}
    var toDelete:Bool {get set}
    var zIndex:Int {get set}
    
}

///Drag and Rotate functions
extension Box {
    
    ///When it's apropriate, pin the object
    mutating func pinRotate(degrees: Double) {
        print("Degree: ", degrees)
        print("///: ",degrees/4)
        let aux = self.rotateState + degrees
        if aux > -3 && aux < 3 {
            self.rotateState = 0
            return
        } else if aux > -183 && aux < -177 {
            self.rotateState = -90
            return
        } else if aux > 177 && aux < 183 {
            self.rotateState = 90
            return
        } else if aux > 357 && aux < 363 {
            self.rotateState = 180
            return
        } else if aux > -363 && aux < -357 {
            self.rotateState = 180
            return
        }
        self.rotateState = degrees
    }
    
    ///Used on rotate
    mutating func setRotateState(degrees: Double) {
        self.rotateState = degrees
    }
    
    ///Used on dragging textbox
    mutating func addToPosition(translation: CGSize) {
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
