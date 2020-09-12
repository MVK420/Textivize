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
    @ObservedObject var textBox:TextBox = TextBox(words: [])
    @State var inputText:String = ""
    
    ///Rotation
    //@State private var offset = CGSize.zero
    //@GestureState private var position = CGSize.zero
    
    ///Selected Object
    @ObservedObject var containers:Container = Container()
    //var containers:[TextBox] = []
    //private var selectedObject:[
    
    ///Builds the Input Text Field
    fileprivate func inputTextField() -> some View {
        return TextField("Text", text: $inputText, onEditingChanged: { (changed) in
            ///When editing is happening, do nothing
        }) {
            //print(self.inputText)
            ///When editing is finished, call func to insert text into a textbox
            self.containers.ls.append(TextBox(words: []))
            self.containers.ls.last?.parseInput(text: self.inputText)
            //self.textBox.parseInput(text: self.inputText)
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
    fileprivate func gradientButton() -> some View {
        return Button(action: self.textBox.calcFont) {
            Text("GR")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(.all)
        .font(.title)
    }
    
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
                                self.containers.ls[i].changeColor(index: i)
                                //---
                                //self.detailPresented = true
                        }
                    }
                }
                    ///VStack properties: offset gesture is for drag, rotationEffect for rotation
                    .offset(self.addToPosition(textBox: self.containers.ls[i], translation:
                        self.containers.ls[i].position)).scaledToFit()
                    .gesture(DragGesture(minimumDistance: 10).updating(self.containers.ls[i].$position, body: {
                        (value, state , translation) in
                        state = value.translation
                        self.containers.objectWillChange.send()
                    }).onEnded({(value) in
                        self.containers.ls[i].offset = self.addToPosition(textBox: self.containers.ls[i], translation: value.translation)
                        self.containers.objectWillChange.send()
                    })
                        .onChanged({(value) in
                            self.containers.objectWillChange.send()
                        })
                )
                    .rotationEffect(Angle(degrees: self.containers.ls[i].rotateState))
                    .gesture(RotationGesture()
                        .onChanged { value in
                            self.containers.ls[i].rotateState = value.degrees
                            self.containers.objectWillChange.send()
                            //self.containers.ls[i].setRotateState(degrees: value.degrees)
                        }
                )
            }
        }
    }
    
    ///Function for rotation
    ///Source: https://www.youtube.com/watch?v=rp9azVjwk-8
    func addToPosition(textBox: TextBox, translation: CGSize) -> CGSize {
        return CGSize(width: textBox.offset.width + translation.width, height: textBox.offset.height + translation.height)
    }
    
    var body : some View {
        ///Main body
        ZStack() {
            HStack(){
                inputTextField()
                gradientButton()
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
