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
    var spacingBool:Bool = false
    var kerning:CGFloat = 20 ///Todo: set this manually
    var spacing:CGFloat = 40 ///Todo: set this manually
    var scaleFact:CGFloat = 0.1
    /// Text for Circle
    
    var texts: [(offset: Int, element:Character)]  {
        return Array(self.text.enumerated())
    }
    
    init(words:[Word], fullText:String) {
        self.text = fullText
        self.words = words
        self.avgFontSize = maxFontSize - minFontSize
        //self.setOgText()
    }
    
    mutating func parseInput(text:String) {
        let array = text.components(separatedBy: " ")
        for word in array {
            let wordObj:Word = Word(text: word, ogText: word, fontSize: self.standardFontSize)
            self.words.append(wordObj)
        }
        //objectWillChange.send()
    }
    
    mutating func setOgText() {
        for i in self.words.indices {
            self.words[i].ogText = self.words[i].text
            print(self.words[i].ogText)
        }
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
    
    mutating func changeColor(index:Int) {
        self.words[index].fontColor = .red
        //objectWillChange.send()
    }
    
    func fontForTextBox() -> CGFloat {
        if self.sameWidth == true {
            return 160
        } else {
            return self.standardFontSize
        }
    }
    
    func scaleFactorForTextBox() -> CGFloat {
        return self.sameWidth ? self.scaleFact : 1
    }
    
    ///If SameWidth is true, return specific width for TextBox
    func widthForTextBox() -> CGFloat {
        if self.sameWidth == true {
            return 100
        } else {
            return 300
        }
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
    
    mutating func resetFontSize() {
        for (index, _) in self.words.enumerated() {
            self.words[index].fontSize = self.standardFontSize
            
        }
    }
    
    mutating func addToPosition(translation: CGSize) {
        self.offset = CGSize(width: self.offset.width + translation.width, height: self.offset.height + translation.height)
    }
    
    func addToPositionReturn(translation: CGSize) -> CGSize{
        let aux = CGSize(width: self.offset.width + translation.width, height: self.offset.height + translation.height)
        return aux
    }
    
    mutating func appendToPosition(translation:CGSize) {
        self.position = CGSize(width: self.position.width + translation.width, height: self.position.height + translation.height)
    }
    
    func combineCGSize(cg1:CGSize, cg2:CGSize) -> CGSize {
        return CGSize(width: cg1.width + cg2.width, height: cg1.height + cg2.height)
    }
    
    mutating func setRotateState(degrees:Double) {
        self.rotateState = degrees
        //objectWillChange.send()
    }
    
    mutating func setAllFonts(font:String) {
        for i in self.words.indices {
            self.words[i].fontStyle = font
        }
    }
    
    mutating func setAllFontsSize(font:CGFloat) {
        for i in self.words.indices {
            self.words[i].fontSize = font
        }
    }
    
    func getKerningString() -> String {
        return self.kerning.description
    }
    
    mutating func addToKerning(val:CGFloat) {
        self.kerning += val
    }
    
}



struct TextBox_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
