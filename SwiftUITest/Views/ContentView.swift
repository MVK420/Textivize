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
    
    ///Notused
    @State var detailPresented = false
    ///selectedColor
    @State var selectedColor = Color(.black)
    ///Bool that checks if all the buttons to edit TextBox need to be presented
    @State var displayEditList = false
    ///Bool that checks if the kerning editor needs to be peresnted
    @State var displayKerningBox = false
    ///Bool that checks if the radius editor needs to be peresnted
    @State var displayRadiusBox = false
    //////Bool that checks if the spacing editor needs to be peresnted
    @State var displaySpacingBox = false
    ///Bool that checks if Font List needs to be presented
    @State private var fontPresented = false
    ///Bool that checks if the gradient min max editor needs to be presented
    @State private var minMaxGradientPresented = false
    ///List of fonts in system
    private let fontList = UIFont.familyNames
    ///In the font list the selected one will be colored
    @State private var selectedFont = 1
    ///Array containing textboxes and imageboxes
    @ObservedObject var containers:Container = Container()
    ///Input Text Field value
    @State var inputText:String = "Nothing lasts forever"
    ///DragGesture values
    @GestureState private var position = CGSize.zero
    ///Selected Object to drag
    @State private var selectedGesture: TextBox? = nil
    @State private var selectedImageGesture: ImageBox? = nil
    ///Selected Object to customize
    //@State private var selectedCustomize : TextBox? = nil
    ///Index of selected TextBox
    @State private var selectedCustomizeImageIndex:Int? = nil
    @State private var selectedCustomizeIndex:Int? = nil
    ///IMAGESTUFF
    @State var showImagePicker: Bool = false
    
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
        .font(.headline)
        .foregroundColor(Color.orange)
    }
    
    ///Builds the Gradient Button
    fileprivate func gradientButton() -> some View {
        return Button(action: {
                        if self.selectedCustomizeIndex != nil {
                            if self.containers.ls[self.selectedCustomizeIndex!].grState < 2 {
                                self.minMaxGradientPresented = true//!self.minMaxGradientPresented
                            } else {
                                self.minMaxGradientPresented = false
                            }
                            self.containers.ls[self.selectedCustomizeIndex!].sameWidth = false
                            self.containers.ls[self.selectedCustomizeIndex!].circleBool = false
                            self.containers.ls[self.selectedCustomizeIndex!].calcFont()
                        }})
        {
            Image(systemName: "g.circle.fill")
        }
        .padding(.all)
        .font(.title)
    }
    
    ///Builds the Circle Button
    fileprivate func circleButton() -> some View {
        return Button(action: {
            if self.selectedCustomizeIndex != nil {
                
                self.containers.ls[self.selectedCustomizeIndex!].sameWidth = false
                let font:CGFloat =  self.containers.ls[self.selectedCustomizeIndex!].fontForTextBox()
                self.containers.ls[self.selectedCustomizeIndex!].setAllFontsSize(font: font)
                self.containers.ls[self.selectedCustomizeIndex!].grState = 0
                self.containers.ls[self.selectedCustomizeIndex!].circleBool = !self.containers.ls[self.selectedCustomizeIndex!].circleBool
                self.displayRadiusBox = self.containers.ls[self.selectedCustomizeIndex!].circleBool
                self.displayKerningBox = self.containers.ls[self.selectedCustomizeIndex!].circleBool
            }
        }) {
            Image(systemName: "circle")
        }
        .padding(.all)
        .font(.title)
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
                                        {if self.selectedCustomizeIndex != nil {
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
        .background(Color.gray)
        .border(Color.orange, width: 4)
        .cornerRadius(7)
        .clipShape(Rectangle())
    }
    
    fileprivate func fontButton() -> some View {
        return Button(action: {
            self.fontPresented = !self.fontPresented
        }) {
            Image(systemName: "f.circle.fill")
        }
        .padding(.all)
        .font(.title)
    }
    
    fileprivate func sameWidthButton() -> some View {
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
            Image(systemName: "w.circle.fill")
        }).font(.title)
        
    }
    
    ///Button that presents the options
    fileprivate func editListButton() -> some View {
        return Button(action: {self.displayEditList = !self.displayEditList}) {
            Image(systemName: "scope")
        }
        .frame(width: 25.0, height: 25.0)
        .border(Color.orange, width: 2)
        .cornerRadius(8)
    }
    
    @available(iOS 14.0, *)
    fileprivate func ColorPick() -> some View {
        return ColorPicker("", selection: $selectedColor).frame(height: 200)
            .onChange(of: self.selectedColor, perform: { value in
                if self.selectedCustomizeIndex != nil {
                    self.containers.ls[selectedCustomizeIndex!].selectedFontColor = self.selectedColor
                    self.containers.ls[selectedCustomizeIndex!].setAllWordColor()
                }
            })
            .frame(width: 25.0, height: 25.0)
            .padding(.all)
            .font(.title)
        
    }
    
    private func selectedAndCircle() -> Bool {
        if self.selectedCustomizeIndex != nil {
            return self.containers.ls[self.selectedCustomizeIndex!].circleBool
        }
        return false
    }

    var body : some View {
        ///Main body
        ///Header
        NavigationView {
            ZStack() {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                ///PopUp Editors
                ZStack{
                    VStack{
                        Spacer()
                        fontScrollView()                        
                    }
                    VStack{
                        Spacer()
                        HStack{
                            SpecSelectBox(containers: self._containers, selected: self.$selectedCustomizeIndex,caseBox: "Kerning")
                                .isHidden(self.displayKerningBox)
                            SpecSelectBox(containers: self._containers, selected: self.$selectedCustomizeIndex,caseBox: "Radius")
                                .isHidden(self.displayRadiusBox)
                            SpecSelectBox(containers: self._containers, selected: self.$selectedCustomizeIndex,caseBox: "Spacing")
                                .isHidden(self.displaySpacingBox)
                            SpecSelectBox(containers: self._containers, selected: self.$selectedCustomizeIndex,caseBox: "Min Gr")
                                .isHidden(self.minMaxGradientPresented)
                            SpecSelectBox(containers: self._containers, selected: self.$selectedCustomizeIndex,caseBox: "Max Gr")
                                .isHidden(self.minMaxGradientPresented)
                            
                        }.frame(alignment: .bottomTrailing)
                    }
                    
                    HStack{
                        Spacer()
                        ///Edit buttons
                        VStack {
                            gradientButton().isHidden(!self.selectedAndCircle())
                            fontButton()
                            sameWidthButton().isHidden(!self.selectedAndCircle())
                            SpecButton(displayBox: self.$displayKerningBox, containers:self._containers, selected: self.$selectedCustomizeIndex, caseBox: "Kerning")
                            SpecButton(displayBox: self.$displayRadiusBox, containers: self._containers, selected: self.$selectedCustomizeIndex, caseBox: "Radius")
                                .isHidden(self.selectedAndCircle())
                            SpecButton(displayBox: self.$displaySpacingBox, containers: self._containers, selected: self.$selectedCustomizeIndex, caseBox: "Spacing").isHidden(!self.selectedAndCircle())
                            AllCapsButton(containers: self._containers, selected: self.$selectedCustomizeIndex,allCaps:true)
                            AllCapsButton(containers: self._containers, selected: self.$selectedCustomizeIndex, allCaps: false)
                            circleButton()
                            
                        }.isHidden(self.displayEditList)
                        .frame(width: 50)
                        .border(Color.orange, width: 2)
                    }
                    
                }
                TextBoxView(containers: self._containers, selectedCustomizeIndex: self.$selectedCustomizeIndex, selectedGesture: self.$selectedGesture)
                ImageBoxView(containers: self._containers, selectedCustomizeImageIndex: self.$selectedCustomizeImageIndex, selectedImageGesture: self.$selectedImageGesture)
            }
            
            .contentShape(Rectangle())
            .onTapGesture {
                self.selectedCustomizeIndex = nil
                self.selectedCustomizeImageIndex = nil
                self.fontPresented = false
                self.displayKerningBox = false
                self.displayRadiusBox = false
                //self.selectedGesture = nil
                print("deselected")
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(sourceType: .photoLibrary) { image in
                    self.containers.images.append(ImageBox(img: image))
                }
            }
            .navigationBarItems(leading: inputTextField()
                                ,trailing:
                                    HStack(){
                                        editListButton()
                                        ImagePickerButton(showImagePicker: self.$showImagePicker)
                                        if #available(iOS 14.0, *) {
                                            ColorPick()
                                        } else {
                                            // Fallback on earlier versions
                                        }
                                    })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
    
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> TupleView<(Self?, Content?)> {
        if conditional { return TupleView((nil, content(self))) }
        else { return TupleView((self, nil)) }
    }
    
}


