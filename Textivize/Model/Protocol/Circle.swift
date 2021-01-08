//
//  CircleView.swift
//  Textivize
//
//  Created by Mozes Vidami on 9/9/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

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

