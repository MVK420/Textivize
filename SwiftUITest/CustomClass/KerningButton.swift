//
//  KerningButton.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/25/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct KerningButton: View {
    var body: some View {
        Button(action: {}) {
            Image(systemName: "k.circle.fill")
        }
    }
}

struct KerningButton_Previews: PreviewProvider {
    static var previews: some View {
        KerningButton()
    }
}
