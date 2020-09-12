//
//  TextBox.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/9/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

class TextBox:ObservableObject {
    
    var words:[Word]
    private var minFontSize:CGFloat = 20
    private var maxFontSize:CGFloat = 80
    private var avgFontSize:CGFloat
    private var grState: Int = 0
    private var standardFontSize:CGFloat = 40
    var rotateState: Double = 0
    var offset = CGSize.zero
    @GestureState var position = CGSize.zero
    
    init(words:[Word]) {
        self.words = words
        self.avgFontSize = maxFontSize - minFontSize
    }
    
    func parseInput(text:String) {
        let array = text.components(separatedBy: " ")
        for word in array {
            let wordObj:Word = Word(text: word, fontSize: self.standardFontSize)
            self.words.append(wordObj)
        }
        objectWillChange.send()
    }
    
    func changeColor(index:Int) {
        self.words[index].fontColor = .red
        objectWillChange.send()
    }
    
    ///On first call: gradually increase fontsize, on second: decrease, on third: reset
    func calcFont() {
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
        objectWillChange.send()
    }
    
    /// Calculate font for each word in array, to gradually increase them
    func increasingFontSize() {
        for (index, _) in self.words.enumerated() {
            let step = Int(self.avgFontSize) / (self.words.count - 1)
            let res = (step * index) + Int(minFontSize)
            self.words[index].fontSize = CGFloat(res)
        }
    }
    
    /// Calculate font for each word in array, to gradually decrease them
    func decreasingFontSize() {
        for (index, _) in self.words.enumerated() {
            let step = Int(self.avgFontSize) / (self.words.count - 1)
            let res = (step * index) + Int(minFontSize)
            self.words[self.words.count - 1 - index].fontSize = CGFloat(res)
        }
    }
    
    func resetFontSize() {
        for (index, _) in self.words.enumerated() {
            self.words[index].fontSize = self.standardFontSize
            
        }
    }
    
    func setRotateState(degrees:Double) {
        self.rotateState = degrees
        objectWillChange.send()
    }
    
}


