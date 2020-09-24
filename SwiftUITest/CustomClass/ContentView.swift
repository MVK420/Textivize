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
    
    var circtxt:CircleText = CircleText()
    
    ///Notused
    @State var detailPresented = false
    ///Bool that checks if Font List needs to be presented
    @State private var fontPresented = false
    //@State private var circlePresented = false
    @State private var selectedFont = 1
    private let fontList = UIFont.familyNames
    //private var fontList = ["Georgia","American Typewriter","Apple SD Gothic Neo","Arial","Avenir","Bodoni 72"]
    ///Array containing textboxes
    @ObservedObject var containers:Container = Container()
    ///Input Text Field value
    @State var inputText:String = "Alma a fa alatt"
    ///DragGesture values
    @GestureState private var position = CGSize.zero
    ///Selected Object to drag
    @State private var selectedGesture: TextBox? = nil
    ///Selected Object to customize
    //@State private var selectedCustomize : TextBox? = nil
    @State private var selectedCustomizeIndex:Int? = nil
    
    ///CIRCLESTUFF
    @State var textSizes: [Int:Double] = [:]
    
    func returnCircle(index:Int,radius:Double,text:String,kerning:CGFloat) -> some View {
        return ZStack {
            ForEach(  self.containers.ls[index].texts, id: \.self.offset) { (offset, element) in
                VStack {
                    Text(String(element))
                        .kerning(kerning)
                        ///FIX index
                        .foregroundColor(self.containers.ls[0].words[0].fontColor)
                        .background(Sizeable())
                        .font(.custom(self.fontList[0], size: 20))
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { size in
                            self.textSizes[offset] = Double(size)
                        })
                    Spacer()
                }
                .rotationEffect(self.angle(at: offset, radius: radius))
                
            }
        }.rotationEffect(-self.angle(at: self.containers.ls[index].texts.count-1, radius: radius)/2)
        .frame(width: 300, height: 300, alignment: .center)
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
    ///ENDOFCIRCLESTUFF
    
    ///Builds the Input Text Field
    fileprivate func inputTextField() -> some View {
        return TextField("Text", text: $inputText, onEditingChanged: { (changed) in
            ///When editing is happening, do nothing
        }) {
            ///When editing is finished, call func to insert text into a textbox
            var tBox = TextBox(words: [],fullText: self.inputText)
            tBox.parseInput(text: self.inputText)
            self.containers.ls.append(tBox)
            ///Empty Text Field
            self.inputText = "Trump For President 2020"
        }
        .onReceive(Just(inputText)) { inputText in
        }
        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(.all)
        .font(.title)
    }
    
    ///Builds the Gradient Button
    fileprivate func gradientButton() -> some View {
        return Button(action: {
                        if self.selectedCustomizeIndex != nil {
                            self.containers.ls[self.selectedCustomizeIndex!].sameWidth = false
                            self.containers.ls[self.selectedCustomizeIndex!].circleBool = false
                            self.containers.ls[self.selectedCustomizeIndex!].calcFont()
                        }})
        {
            Text("G")
        }
        .frame(minWidth: 10, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(.all)
        .font(.title)
    }
    
    ///Builds the Circle Button
    fileprivate func circleButton() -> some View {
        return Button(action: {
            if self.selectedCustomizeIndex != nil {
                self.containers.ls[self.selectedCustomizeIndex!].sameWidth = false
                self.containers.ls[self.selectedCustomizeIndex!].grState = 0
                self.containers.ls[self.selectedCustomizeIndex!].circleBool = !self.containers.ls[self.selectedCustomizeIndex!].circleBool
            }
        }) {
            Image(systemName: "circle")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading)
        .padding(.top)
        .font(.title)
    }
    
    ///Builds the VStack that contains the words one above the other
    fileprivate func VStackTextBox() -> some View {
        return Group{
            ///Loop through each word in textbox.words
            ForEach(self.containers.ls.indices, id: \.self) { i in
                VStack (spacing: self.containers.ls[i].spacingForTextBox()){//(alignment: .leading, spacing: 20) {
                    if self.containers.ls[i].circleBool == true{
                        returnCircle(index: i, radius: 90, text: "Trump For President 2020", kerning: 9)
                    } else {
                        ForEach(self.containers.ls[i].words.indices, id: \.self) { j in
                            ///Create a Text for each word
                            ///setup font, color, onClick to Detail,
                            Text(self.containers.ls[i].words[j].text)
                                .kerning(self.containers.ls[i].kerningForTextBox())
                                .font(.custom(self.containers.ls[i].words[j].fontStyle, size: self.containers.ls[i].words[j].fontSize))
                                .minimumScaleFactor(self.containers.ls[i].scaleFactorForTextBox())
                                .lineLimit(1)
                                .foregroundColor(self.containers.ls[i].words[j].fontColor)
                                .sheet(isPresented: self.$detailPresented) { DetailView(detailPresented: self.$detailPresented) }
                                .onTapGesture {
                                    ///Remove this eventually
                                    //self.containers.ls[i].changeColor(index: j)
                                    //---
                                    //self.detailPresented = true
                                    //self.selectedCustomize = self.containers.ls[i]
                                    self.selectedCustomizeIndex = i
                                }
                        }
                    }
                }
                .frame(width: self.containers.ls[i].widthForTextBox())
                //.fixedSize(horizontal:false, vertical: true)
                .border(self.selectedCustomizeIndex == i ? Color.black : Color.clear)
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
                                }
                            })
                            .onEnded() { value in
                                if self.selectedGesture == self.containers.ls[i] {
                                    self.containers.ls[i].appendToPosition(translation: value.translation)
                                }
                                self.selectedGesture = nil
                                //self.containers.ls[i].addToPosition(translation: value.translation)
                            })
                //.rotationEffect(Angle(degrees: self.containers.ls[i].rotateState))
                //Fix this for rotationAnchor
                .rotationEffect(Angle(degrees: self.containers.ls[i].rotateState),anchor: self.containers.ls[i].rotationAnchor())
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
    
    fileprivate func fontScrollView() -> some View {
        return ScrollView(.vertical) {
            VStack() {
                ForEach(0..<self.fontList.count, id: \.self) { i in
                    Text("\(self.fontList[i])")
                        .font(.custom(self.fontList[i], size: 20))
                        .foregroundColor(self.selectedFont == i ? .red : .black)
                        .lineLimit(nil)
                        .frame(width: 500, height: 20)
                        .gesture(TapGesture()
                                    .onEnded(
                                        {
                                            if self.selectedCustomizeIndex != nil {
                                                self.containers.ls[self.selectedCustomizeIndex!].setAllFonts(font: self.fontList[i])
                                            }
                                            self.selectedFont = i
                                            
                                        }
                                    )
                        )
                }
            }
        }
        .frame(width: 250, height: 220)
        .isHidden(self.fontPresented)
        .border(Color.orange, width: 2)
        .clipShape(Rectangle())
        
    }
    
    fileprivate func fontButton() -> some View {
        return Button(action: {
            self.fontPresented = true
        }) {
            Text("F")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(.all)
        .font(.title)
    }
    
    fileprivate func sameWidthButton() -> Button<Text> {
        return Button(action: {
            ///If there's a Textbox that is selected to customize
            if self.selectedCustomizeIndex != nil {
                ///Set other bools to false
                self.containers.ls[self.selectedCustomizeIndex!].circleBool = false
                self.containers.ls[self.selectedCustomizeIndex!].grState = 0
                ///SameWidth = !SameWidth
                self.containers.ls[self.selectedCustomizeIndex!].sameWidth = !self.containers.ls[self.selectedCustomizeIndex!].sameWidth
                ///Get font size (standard for textbox if sameWidth = false, 160 if true, that will be scaled down)
                let font:CGFloat =  self.containers.ls[self.selectedCustomizeIndex!].fontForTextBox()
                self.containers.ls[self.selectedCustomizeIndex!].setAllFontsSize(font: font)
            }
        }, label: {
            Text("W")
        })
    }
    
    var body : some View {
        ///Main body
        NavigationView {
            ZStack() {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                VStack(){
                    fontScrollView()
                    ///Spacer to push ScrollView to the top of the screen
                    Spacer()
                }
                VStackTextBox()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.selectedCustomizeIndex = nil
                self.fontPresented = false
                //self.selectedGesture = nil
                print("deselected")
            }
            .navigationBarItems(leading:
                                    HStack(){
                                        inputTextField()
                                        gradientButton()
                                        fontButton()
                                        sameWidthButton()
                                        circleButton()
                                    }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //CircleText(radius: 90, text: "Lorem ipsum dolor",kerning: 9)
    }
}

extension View {
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    /// ```
    /// Text("Label")
    ///     .isHidden(true)
    /// ```
    ///
    /// Example for complete removal:
    /// ```
    /// Text("Label")
    ///     .isHidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if !hidden {
            if remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
