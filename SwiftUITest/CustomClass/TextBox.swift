//
//  TextBox.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/9/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct TextBox: Identifiable, Equatable {
    
    var id = UUID()
    var words:[Word] = [Word]()
    var text:String = ""
    var selectedFontColor:Color = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    var minFontSize:CGFloat = 20
    var maxFontSize:CGFloat = 80 ///Todo: set this manually
    var avgFontSize:CGFloat = 40
    var grState: Int = 0
    var allCapsState: Int = 0
    var capitaState:Int = 0
    var standardFontSize:CGFloat = 40 ///Todo: set this manually
    var rotateState: Double = 0
    var offset = CGSize.zero
    var position = CGSize.zero
    var sameWidth:Bool = false
    var circleBool:Bool = false
    var kerningBool:Bool = false
    var radiusBool:Bool = false
    var spacingBool:Bool = false
    var radius:Double = 180
    var kerning:CGFloat = 0
    var spacing:CGFloat = 0
    var scaleFact:CGFloat = 0.1
    /// Text for Circle
    var texts: [(offset: Int, element:Character)]  {
        return Array(self.text.enumerated())
    }
    
    init(words:[Word], fullText:String) {
        self.text = fullText
        self.words = words
        self.avgFontSize = maxFontSize - minFontSize
    }
    
    ///Called when something was entered in textfield and creates a struct for each word
    mutating func parseInput(text:String) {
        let array = text.components(separatedBy: " ")
        for word in array {
            let wordObj:Word = Word(text: word, ogText: word, fontSize: self.standardFontSize)
            self.words.append(wordObj)
        }
        //objectWillChange.send()
    }
    
    ///TODO: First Case, if words ends with . ? ! then capitalize next word.
    mutating func capitalize() {
        if self.capitaState == 0 {
            self.words[0].text = self.words[0].text.capitalized
            self.capitaState += 1
            return
        } else if self.capitaState == 1 {
            for i in self.words.indices {
                self.words[i].text = self.words[i].text.capitalized
            }
            self.capitaState += 1
            return
        } else {
            for i in self.words.indices {
                self.words[i].text = self.words[i].ogText
            }
            self.capitaState = 0
            return
        }
    }
    
    ///This is ugly, fix this shit
    mutating func allCaps() {
        if allCapsState == 0 {
            for i in self.words.indices {
                self.words[i].text = self.words[i].text.uppercased()
            }
            self.allCapsState += 1
            return
        } else if allCapsState == 1 {
            for i in self.words.indices {
                self.words[i].text = self.words[i].text.lowercased()
            }
            self.allCapsState += 1
            return
        } else {
            for i in self.words.indices {
                self.words[i].text = self.words[i].ogText
            }
            self.allCapsState = 0
            return
        }
    }
    
    ///
//    mutating func changeColor(index:Int) {
//        self.words[index].fontColor = .red
//        //objectWillChange.send()
//    }
//
    
    ///Set every words color to the selected
    mutating func setAllWordColor() {
        for i in self.words.indices {
            self.words[i].fontColor = self.selectedFontColor
        }
    }
    
    ///Calculate
    func fontForTextBox() -> CGFloat {
        return self.sameWidth == true ? 160 : self.standardFontSize
    }
    
    func scaleFactorForTextBox() -> CGFloat {
        return self.sameWidth ? self.scaleFact : 1
    }
    
    ///If SameWidth is true, return specific width for TextBox
    func widthForTextBox() -> CGFloat {
        return self.sameWidth == true ? 100 : 300
    }
    
    ///If kerningBool is true, return specific kerning for TextBox
    func kerningForTextBox() -> CGFloat {
        return self.kerningBool ? self.kerning : 0
    }
    
    ///If spacingBool is true, return specific spacing for TextBox
    func spacingForTextBox() -> CGFloat {
        return self.spacingBool ? self.spacing : 0
    }
    
    ///Function to figure out middle of view, to make rotation work
    ///Not Working yet
    func rotationAnchor() -> UnitPoint {
        return UnitPoint(x: self.offset.width, y: self.offset.height)
    }
    
    ///On first call: gradually increase fontsize, on second: decrease, on third: reset
    mutating func calcFont() {
        if self.grState == 0 {
            self.increasingFontSize()
        } else if grState == 1 {
            self.decreasingFontSize()
        }
        if self.grState == 2 {
            self.grState = -1
            self.resetFontSize()
        }
        self.grState += 1
    }
    
    /// Calculate font for each word in array, to gradually increase them
    mutating func increasingFontSize() {
        for (index, _) in self.words.enumerated() {
            let step = Int(self.avgFontSize) / (self.words.count - 1)
            let res = (step * index) + Int(minFontSize)
            self.words[index].fontSize = CGFloat(res)
        }
    }
    
    /// Calculate font for each word in array, to gradually decrease them
    mutating func decreasingFontSize() {
        for (index, _) in self.words.enumerated() {
            let step = Int(self.avgFontSize) / (self.words.count - 1)
            let res = (step * index) + Int(minFontSize)
            self.words[self.words.count - 1 - index].fontSize = CGFloat(res)
        }
    }
    
    ///Set each words font to the preset standard
    mutating func resetFontSize() {
        for (index, _) in self.words.enumerated() {
            self.words[index].fontSize = self.standardFontSize
            
        }
    }
    
    ///Set all each words font to one in parameter
    mutating func setAllFontsSize(font:CGFloat) {
        for i in self.words.indices {
            self.words[i].fontSize = font
        }
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
    
    ///Used on rotate
    mutating func setRotateState(degrees:Double) {
        self.rotateState = degrees
        //objectWillChange.send()
    }
    
    ///Set each words font to the one received as parameter
    mutating func setAllFonts(font:String) {
        for i in self.words.indices {
            self.words[i].fontStyle = font
        }
    }
    
    ///For caseBox, return the value of respective variable
    func getString(caseBox:String) -> String {
        switch caseBox {
        case "Kerning":
            return self.kerning.description
        case "Radius":
            return self.radius.description
        case "Spacing":
            return self.spacing.description
        default:
            return ""
        }
    }
    
//
//    mutating func addToKerning(val:CGFloat) {
//        self.kerning += val
//    }
//
//    mutating func addToRadius(val:Double) {
//        self.radius += val
//    }
//
    mutating func addToCase<T:BinaryInteger>(caseBox:String, val: T) {
        switch caseBox {
        case "Kerning":
            self.kerning += CGFloat(val)
        case "Radius":
            self.radius += Double(val*10)
        case "Spacing":
            self.spacing += CGFloat(val)
        default:
            return
        }
    }
    
}
