//
//  CircleView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/9/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

///Source: https://medium.com/dwarves-foundation/create-circular-text-using-swiftui-32cd7e5b6414
struct CircleText_Preview: PreviewProvider {
    static var previews: some View {
        CircleText(text: "")
    }
}


func presentCircle(radius:Double,text:[String],kerning:CGFloat) {
    
}




//MARK: - CircleLabel
struct CircleText: View {
    
    var text: String = "Alma fa 2"
    
    private var texts: [(offset: Int, element:Character)]  {
        
        return Array(text.enumerated())
    }
    
    @State var textSizes: [Int:Double] = [:]
    
    func returnCircle(radius:Double,text:String,kerning:CGFloat) -> some View {
        return ZStack {
            ForEach(  self.texts, id: \.self.offset) { (offset, element) in
                VStack {
                    Text(String(element))
                        .kerning(kerning)
                        .foregroundColor(Color.blue)
                        .font(.custom("Georgia",size: 50))
                        .background(Sizeable())
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                            self.textSizes[offset] = Double(size)
                        })
                    Spacer()
                }
                .rotationEffect(self.angle(at: offset, radius: radius))
                
            }
        }.rotationEffect(-self.angle(at: self.texts.count-1, radius: radius)/2)
        
        .frame(width: 300, height: 300, alignment: .center)
    }
    
    var body: some View {
        returnCircle(radius: 90, text: "Hellobello", kerning: 9)
    }
    
    private func angle(at index: Int, radius:Double) -> Angle {
        guard let labelSize = textSizes[index] else {return .radians(0)}
        let percentOfLabelInCircle = labelSize / radius.perimeter
        let labelAngle = 2 * Double.pi * percentOfLabelInCircle
        
        
        let totalSizeOfPreChars = textSizes.filter{$0.key < index}.map{$0.value}.reduce(0,+)
        let percenOfPreCharInCircle = totalSizeOfPreChars / radius.perimeter
        let angleForPreChars = 2 * Double.pi * percenOfPreCharInCircle
        
        return .radians(angleForPreChars + labelAngle)
    }
    
}



extension Double {
    var perimeter: Double {
        return self * 2 * .pi
    }
}


//Get size for label helper
struct WidthPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat(0)
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
struct Sizeable: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}
