//
//  MVVMMain.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 12/31/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct MVVMMain: View {
    
    @ObservedObject var container:ContainerMVVM = ContainerMVVM()
    
    var body : some View {
        NavigationView {
            ZStack(){
                Color.white
                    .edgesIgnoringSafeArea(.all)
                Group{
                    ///Loop through each word in textbox.words
                    ForEach(self.container.text.indices, id: \.self) { i in
                        ///Create a VStack with alignemnt and leading of TextBox
                        MVVMTextView(textViewModel: self.$container.text[i])
                    }
                }
            }.navigationBarItems(leading: HStack() {
                InpTextFieldView(container: self.container)
            })
        }
    }
    
}


struct MVVMMain_Previews: PreviewProvider {
    static var previews: some View {
        MVVMMain()
    }
}

