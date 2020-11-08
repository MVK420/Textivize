//
//  TextBox.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/9/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct TextBox: Box {
    
    var id:UUID = UUID()
    var words:[Word] = [Word]()
    var text:String = ""
    var selectedFontColor:Color = Color(.sRGB, red: 0.98, green: 0.9, blue: 0.2)
    var minFontSize:CGFloat = 20
    var maxFontSize:CGFloat = 80
    var avgFontSize:CGFloat = 40
    var standardFontSize:CGFloat = 40 ///Todo: set this manually
    var alignment:HorizontalAlignment = .center
    var radius:Double = 180
    var kerning:CGFloat = 0
    var spacing:CGFloat = 0
    var scaleFact:CGFloat = 0.1
    var scale:CGFloat = 1
    var rotateState: Double = 0
    //var offset = CGSize.zero
    var offset = CGSize(width: 0.5, height: 0.5)
    var position = CGSize.zero
    var grState: Int = 0
    var allCapsState: Int = 0
    var capitaState:Int = 0
    var sameWidth:Bool = false
    var circleBool:Bool = false
    var kerningBool:Bool = false
    var radiusBool:Bool = false
    var spacingBool:Bool = false
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
    
    ///onSwipe adjust alignement accordignly
    mutating func alignmentForTextBox(swipeVal:CGSize) {
        if swipeVal.width > 0 {
            self.alignment = self.alignment == .leading ? .center : .trailing
        } else if swipeVal.width < 0{
            self.alignment = self.alignment == .trailing ? .center : .leading
        }
    }
    
    ///If spacingBool is true, return specific spacing for TextBox
    func spacingForTextBox() -> CGFloat {
        return self.spacingBool ? self.spacing : 0
    }
    
    ///On first call: gradually increase fontsize, on second: decrease, on third: reset
    mutating func calcFont() {
        switch self.grState {
        case 0:
            self.increasingFontSize()
        case 1:
            self.decreasingFontSize()
        case 2:
            self.resetFontSize()
            self.grState = -1
        default:
            return
        }
        self.grState += 1
    }
    
    ///Recalculated fontsizes when min or max is modifed
    mutating func calcFontForGr() {
        if self.grState == 1 {
            self.increasingFontSize()
        } else if grState == 2 {
            self.decreasingFontSize()
        }
        if self.grState == 0 {
            self.resetFontSize()
        }
    }
    
    /// Calculate font for each word in array, to gradually increase them
    mutating func increasingFontSize() {
        for i in self.words.indices {
            let step = Int(self.maxFontSize - self.minFontSize) / (self.words.count - 1)
            let res = (step * i) + Int(minFontSize)
            self.words[i].fontSize = CGFloat(res)
        }
    }
    
    /// Calculate font for each word in array, to gradually decrease them
    mutating func decreasingFontSize() {
        for i in self.words.indices {
            let step = Int(self.maxFontSize - self.minFontSize) / (self.words.count - 1)
            let res = (step * i) + Int(minFontSize)
            self.words[self.words.count - 1 - i].fontSize = CGFloat(res)
        }
    }
    
    ///Set each words font to the preset standard
    mutating func resetFontSize() {
        for i in self.words.indices {
            self.words[i].fontSize = self.standardFontSize
        }
    }
    
    ///Set all each words font to one in parameter
    mutating func setAllFontsSize(font:CGFloat) {
        for i in self.words.indices {
            self.words[i].fontSize = font
        }
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
        case "Min Gr":
            return self.minFontSize.description
        case "Max Gr":
            return self.maxFontSize.description
        default:
            return ""
        }
    }
    
    ///Add val to the value represented in casebox
    mutating func addToCase<T:BinaryInteger>(caseBox:String, val: T) {
        switch caseBox {
        case "Kerning":
            self.kerning += CGFloat(val)
        case "Radius":
            if self.radius > 10 || val == +1 {
                self.radius += Double(val*10)
            }
        case "Spacing":
            self.spacing += CGFloat(val)
        case "Min Gr":
            self.minFontSize += CGFloat(val)
            self.calcFontForGr()
        case "Max Gr":
            self.maxFontSize += CGFloat(val)
            self.calcFontForGr()
        default:
            return
        }
    }
    
}
