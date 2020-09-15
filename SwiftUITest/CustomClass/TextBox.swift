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
    var minFontSize:CGFloat = 20
    var maxFontSize:CGFloat = 80
    var avgFontSize:CGFloat = 40
    var grState: Int = 0
    var standardFontSize:CGFloat = 40
    var rotateState: Double = 0
    var offset = CGSize.zero
    var position = CGSize.zero
    
    init(words:[Word]) {
        self.words = words
        self.avgFontSize = maxFontSize - minFontSize
    }
    
    mutating func parseInput(text:String) {
        let array = text.components(separatedBy: " ")
        for word in array {
            let wordObj:Word = Word(text: word, fontSize: self.standardFontSize)
            self.words.append(wordObj)
        }
        //objectWillChange.send()
    }
    
    mutating func changeColor(index:Int) {
        self.words[index].fontColor = .red
        //objectWillChange.send()
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
        //objectWillChange.send()
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
}


