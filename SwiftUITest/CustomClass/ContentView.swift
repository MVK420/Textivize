//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/2/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @State var detailPresented = false
    @ObservedObject var containers:Container = Container()
    @State var inputText:String = ""
    @GestureState private var position = CGSize.zero
    
    ///Selected Object
    @State private var selectedGesture: TextBox? = nil
    @State private var selectedCustomize : TextBox? = nil
    
    ///Builds the Input Text Field
    fileprivate func inputTextField() -> some View {
        return TextField("Text", text: $inputText, onEditingChanged: { (changed) in
            ///When editing is happening, do nothing
        }) {
            ///When editing is finished, call func to insert text into a textbox
            var tBox = TextBox(words: [])
            tBox.parseInput(text: self.inputText)
            self.containers.ls.append(tBox)
            ///Empty Text Field
            self.inputText = ""
        }
        .onReceive(Just(inputText)) { inputText in
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(.all)
        .font(.title)
    }
    
    ///Builds the Gradient Button
    /*
     fileprivate func gradientButton() -> some View {
     return Button(action: self.containers.ls[0].calcFont) {
     Text("GR")
     }
     .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
     .padding(.all)
     .font(.title)
     }
     */
    
    ///Builds the Circle Button
    fileprivate func circleButton() -> some View {
        return Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            Image(systemName: "circle")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(.all)
        .font(.title)
    }
    
    ///Builds the VStack that contains the words one above the other
    fileprivate func VStackTextBox() -> some View {
        return Group{
            ///Loop through each word in textbox.words
            ForEach(self.containers.ls.indices, id: \.self) { i in
                VStack {
                    ForEach(self.containers.ls[i].words.indices, id: \.self) { j in
                        ///Create a Text for each word
                        ///setup font, color, onClick to Detail,
                        Text(self.containers.ls[i].words[j].text)
                            .font(.system(size: self.containers.ls[i].words[j].fontSize))
                            .foregroundColor(self.containers.ls[i].words[j].fontColor)
                            .sheet(isPresented: self.$detailPresented) { DetailView(detailPresented: self.$detailPresented) }
                            .onTapGesture {
                                //Remove this eventually
                                self.containers.ls[i].changeColor(index: j)
                                //---
                                //self.detailPresented = true
                        }
                    }
                }
                    ///VStack properties: offset gesture is for drag, rotationEffect for rotation
                    //.offset(self.containers.ls[i].addToPositionReturn(translation: self.position)).scaledToFit()
                    .offset(self.selectedGesture == self.containers.ls[i] ? self.position : self.containers.ls[i].position).scaledToFit()
                    .gesture(DragGesture(minimumDistance: 10)
                        .updating(self.$position, body: { (value, state, translation) in
                            if nil == self.selectedGesture {
                                self.selectedGesture = self.containers.ls[i]
                            } else {
                                let aux = self.containers.ls[i].position
                                let res = CGSize(width: aux.width + value.translation.width, height: aux.height + value.translation.height)
                                state = res
                                print("2: ", self.containers.ls[i].position)
                            }
                        })
                    .onEnded() { value in
                        if self.selectedGesture == self.containers.ls[i] {
                            self.containers.ls[i].appendToPosition(translation: value.translation)
                        }
                        self.selectedGesture = nil
                        //self.containers.ls[i].addToPosition(translation: value.translation)
                    })
                    .rotationEffect(Angle(degrees: self.containers.ls[i].rotateState))
                    .gesture(RotationGesture()
                        .onChanged { value in
                            self.containers.ls[i].rotateState = value.degrees
                            self.containers.objectWillChange.send()
                    })
                
            }
        }
    }
    
    ///Function for rotation
    ///Source: https://www.youtube.com/watch?v=rp9azVjwk-8
    func addToPosition2(textBox: TextBox, translation: CGSize) -> CGSize {
        //self.containers.objectWillChange.send()
        return CGSize(width: textBox.offset.width + translation.width, height: textBox.offset.height + translation.height)
    }
    
    var body : some View {
        ///Main body
        ZStack() {
            HStack(){
                inputTextField()
                //gradientButton()
                circleButton()
            }
            VStackTextBox()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //CircleText(radius: 90, text: "Lorem ipsum dolor",kerning: 9)
    }
}
