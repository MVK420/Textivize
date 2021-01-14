//
//  ContentView.swift
//  Textivize
//
//  Created by Mozes Vidami on 9/2/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI
import Combine
import SVGKit
import GoogleMobileAds

struct ContentView: View {
    
    @ObservedObject private var interstitialService:InterstitialService = InterstitialService()
    ///Show navBar
    @State private var navBar:Bool = false
    @State var backgroundColor:Color = Color.clear
    ///selectedColor
    @State private var selectedColor = Color(.black)
    ///Bool that checks if all the buttons to edit TextBox need to be presented
    @State private var displayEditList:Bool = false
    ///Bool that checks if the kerning editor needs to be peresnted
    @State private var displayKerningBox:Bool = false
    ///Bool that checks if the radius editor needs to be peresnted
    @State private var displayRadiusBox:Bool = false
    ///Bool that checks if the spacing editor needs to be peresnted
    @State private var displaySpacingBox:Bool = false
    ///Bool that checks if Font List needs to be presented
    @State private var fontPresented:Bool = false
    ///Bool that checks if the gradient min max editor needs to be presented
    @State private var minMaxGradientPresented:Bool = false
    ///In the font list the selected one will be colored
    @State private var selectedFont = 1
    ///Array containing textboxes and imageboxes
    @ObservedObject private var containers:Container = Container()
    ///DragGesture values
    @GestureState private var position = CGSize.zero
    ///Selected Object to drag
    @State private var selectedGesture:TextBox? = nil
    @State private var selectedImageGesture:ImageBox? = nil
    @State private var selectedSVGGesture:SVGBox? = nil
    ///Selected Object to customize
    //@State private var selectedCustomize : TextBox? = nil
    ///Index of selected TextBox
    @State private var selectedCustomizeSVGIndex:Int? = nil
    @State private var selectedCustomizeImageIndex:Int? = nil
    @State private var selectedCustomizeIndex:Int? = nil
    ///IMAGESTUFF
    @State private var showFilePicker:Bool = false
    @State private var showImagePicker:Bool = false
    ///To specify which area to save
    @State private var rect1: CGRect = .zero
            
    var body : some View {
        ///Main body
        ///Header
        NavigationView {
            ZStack() {
                self.backgroundColor
                    .edgesIgnoringSafeArea(.bottom)
                ///PopUp Editors
                ZStack{
                    VStack{
                        Spacer()
                        FontScrollView(containers: self.containers, selectedFont: self.$selectedFont, fontPresented: self.$fontPresented,selectedCustomizeIndex: self.selectedCustomizeIndex)
                    }
                    VStack{
                        Spacer()
                        ZStack{
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
                            }
                            Button(action:{}) {
                                Image(systemName: "trash")
                                    .isHidden(hideTrashCan(text: self.selectedGesture, img: self.selectedImageGesture, svg: self.selectedSVGGesture))
                                    .scaleEffect(1.5)
                            }
                        }.frame(alignment: .bottomTrailing)
                    }
                    HStack{
                        Spacer()
                        ///Edit buttons
                        VStack {
                            GradientButtonView(containers: self.containers, selectedCustomizeIndex: self.selectedCustomizeIndex, minMaxGradientPresented: self.$minMaxGradientPresented)
                            FontButtonView(fontPresented: self.$fontPresented)
                            SameWidthButtonView(containers: self.containers, selectedCustomizeIndex: self.selectedCustomizeIndex)
                            SpecButton(displayBox: self.$displayKerningBox, containers:self._containers, selected: self.$selectedCustomizeIndex, caseBox: "Kerning")
                            SpecButton(displayBox: self.$displayRadiusBox, containers: self._containers, selected: self.$selectedCustomizeIndex, caseBox: "Radius")
                                .isHidden(self.selectedAndCircle(containers: self.containers, selectedCustomizeIndex: self.selectedCustomizeIndex))
                            SpecButton(displayBox: self.$displaySpacingBox, containers: self._containers, selected: self.$selectedCustomizeIndex, caseBox: "Spacing").isHidden(!self.selectedAndCircle(containers: self.containers, selectedCustomizeIndex: self.selectedCustomizeIndex))
                            AllCapsButton(containers: self._containers, selected: self.$selectedCustomizeIndex,allCaps:true)
                            AllCapsButton(containers: self._containers, selected: self.$selectedCustomizeIndex, allCaps: false)
                            CircleButtonView(containers: self.containers,selectedCustomizeIndex: self.selectedCustomizeIndex, displayRadiusBox: self.$displayRadiusBox, displayKerningBox: self.$displayKerningBox)
                            /*
                             ///Not used, for installing fonts
                            NavigationLink(destination: FontSettingsView()) {
                                Image(systemName: "scribble")
                            }
                            */
                        }.isHidden(self.displayEditList)
                        .frame(width: 50)
                        .border(Color.orange, width: 2)
                    }
                }
                ///Stackoverflow Voodoo to make 2 sheets presentable
                Text("")
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(sourceType: .photoLibrary) { image in
                            self.containers.images.append(ImageBox(img: image))
                        }
                    }
                Text("")
                    .sheet(isPresented: $showFilePicker) {
                        DocumentPicker() { svgImage in
                            self.containers.svgs.append(SVGBox(img:svgImage))
                        }
                    }
                ///End of Stackoverflow Voodoo
                TextBoxView(containers: self.containers, selectedCustomizeIndex: self.$selectedCustomizeIndex, selectedGesture: self.$selectedGesture)
                ImageBoxView(containers: self.containers, selectedCustomizeImageIndex: self.$selectedCustomizeImageIndex, selectedImageGesture: self.$selectedImageGesture)
                SVGBoxVIew(containers: self.containers, selectedCustomizeSVGIndex: self.$selectedCustomizeSVGIndex, selectedSVGGesture: self.$selectedSVGGesture)
            }
            .background(RectGetter(rect: $rect1))
            .background(Color.gray.opacity(0.5))
            .contentShape(Rectangle())
            .onTapGesture {
                self.onTap()
                print("deselected")
            }
            .navigationBarHidden(navBar)
            .navigationBarItems(leading: HStack() {
                inputTextFieldView(containers: self.containers)
            }
            ,trailing:
                HStack(){
                    VStack {
                    Menu("Options") {
                        CustomizeButtonView(displayEditList: self.$displayEditList)
                        ImagePickerButton(showImagePicker: self.$showImagePicker)
                        DocumentPickerButton(showFilePicker: self.$showFilePicker)
                    }.padding(.top)
                    SaveButton(interstitialService: self.interstitialService, rect1: self.$rect1)
                    }
                    ColorPickerView(selectedColor: self.$selectedColor, backgroundColor: $backgroundColor, selectedCustomizeIndex: self.selectedCustomizeIndex, containers: self.containers)
                })
        }.environment(\.parrentFunc, onClickSaveButton)
        .onAppear {
            self.interstitialService.loadInterstitial()
        }
    }
    
    func onTap() {
        self.hideEverything()
    }
    
    func onClickSaveButton() {
        self.displayEditList = false
        self.hideEverything()
    }
    
    func hideEverything() {
        self.displayKerningBox = false
        self.displayRadiusBox = false
        self.displaySpacingBox = false
        self.fontPresented = false
        self.minMaxGradientPresented = false
        self.selectedGesture = nil
        self.selectedSVGGesture = nil
        self.selectedImageGesture = nil
        self.selectedCustomizeIndex = nil
        self.selectedCustomizeIndex = nil
        self.selectedCustomizeSVGIndex = nil
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
    
    ///if conditional is true, then apply modifier to view
    ///.if(self.selectedCustomizeIndex == i ? true : false) {$0.RotationText(i: i, containers: self.containers)}
    //    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> TupleView<(Self?, Content?)> {
    //        if conditional { return TupleView((nil, content(self))) }
    //        else { return TupleView((self, nil)) }
    //    }
    
    fileprivate func hideTrashCan(text: TextBox?, img: ImageBox?, svg: SVGBox?) -> Bool{
        if text == nil && img == nil && svg == nil{
            return false
        }
        return true
    }
    
    func selectedAndCircle(containers:Container ,selectedCustomizeIndex:Int?) -> Bool {
        if selectedCustomizeIndex != nil {
            return containers.txt[selectedCustomizeIndex!].circleBool
        }
        return false
    }
    
}

