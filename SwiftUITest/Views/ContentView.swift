//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 9/2/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI
import Combine
import SVGKit

struct ContentView: View {
    
    ///selectedColor
    @State var selectedColor = Color(.black)
    ///Bool that checks if all the buttons to edit TextBox need to be presented
    @State var displayEditList:Bool = false
    ///Bool that checks if the kerning editor needs to be peresnted
    @State var displayKerningBox:Bool = false
    ///Bool that checks if the radius editor needs to be peresnted
    @State var displayRadiusBox:Bool = false
    //////Bool that checks if the spacing editor needs to be peresnted
    @State var displaySpacingBox:Bool = false
    ///Bool that checks if Font List needs to be presented
    @State private var fontPresented:Bool = false
    ///Bool that checks if the gradient min max editor needs to be presented
    @State private var minMaxGradientPresented:Bool = false
    ///In the font list the selected one will be colored
    @State private var selectedFont = 1
    ///Array containing textboxes and imageboxes
    @ObservedObject var containers:Container = Container()
    ///DragGesture values
    @GestureState private var position = CGSize.zero
    ///Selected Object to drag
    @State private var selectedGesture:TextBox? = nil
    @State private var selectedImageGesture:ImageBox? = nil
    ///Selected Object to customize
    //@State private var selectedCustomize : TextBox? = nil
    ///Index of selected TextBox
    @State private var selectedCustomizeImageIndex:Int? = nil
    @State private var selectedCustomizeIndex:Int? = nil
    ///IMAGESTUFF
    @State var showFilePicker:Bool = false
    @State var showImagePicker:Bool = false
    @State var urlPicked:URL = URL(fileURLWithPath: "private/var/mobile/Containers/Shared/AppGroup/65AD5CAA-658F-4BD0-A94E-8BA093460BE2/File%20Provider%20Storage/svg/001-mummy.svg")
    
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
                        FontScrollView(containers: self.containers, selectedFont: self.$selectedFont, fontPresented: self.$fontPresented,selectedCustomizeIndex: self.selectedCustomizeIndex)
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
                            GradientButtonView(containers: self.containers, selectedCustomizeIndex: self.selectedCustomizeIndex, minMaxGradientPresented: self.$minMaxGradientPresented)
                            FontButtonView(fontPresented: self.$fontPresented)
                            SameWidthButtonView(containers: self.containers, selectedCustomizeIndex: self.selectedCustomizeIndex)
                            SpecButton(displayBox: self.$displayKerningBox, containers:self._containers, selected: self.$selectedCustomizeIndex, caseBox: "Kerning")
                            SpecButton(displayBox: self.$displayRadiusBox, containers: self._containers, selected: self.$selectedCustomizeIndex, caseBox: "Radius")
                                .isHidden(self.selectedAndCircle(containers: self.containers, selectedCustomizeIndex: self.selectedCustomizeIndex))
                            SpecButton(displayBox: self.$displaySpacingBox, containers: self._containers, selected: self.$selectedCustomizeIndex, caseBox: "Spacing").isHidden(!self.selectedAndCircle(containers: self.containers, selectedCustomizeIndex: self.selectedCustomizeIndex))
                            AllCapsButton(containers: self._containers, selected: self.$selectedCustomizeIndex,allCaps:true)
                            AllCapsButton(containers: self._containers, selected: self.$selectedCustomizeIndex, allCaps: false)
                            DocumentPickerButton(showFilePicker: self.$showFilePicker)
                            CircleButtonView(containers: self.containers,selectedCustomizeIndex: self.selectedCustomizeIndex, displayRadiusBox: self.$displayRadiusBox, displayKerningBox: self.$displayKerningBox)
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
                        DocumentPicker(url: self.$urlPicked)
                    }
                ///End of Stackoverflow Voodoo
                SVGKFastImageViewSUI(paramUrl: self.$urlPicked).border(Color.red)
                    .frame(width: 200, height: 200)
                Button(action: {print(self.urlPicked)}) {
                    Text("ALMA")
                }
                TextBoxView(containers: self.containers, selectedCustomizeIndex: self.$selectedCustomizeIndex, selectedGesture: self.$selectedGesture)
                ImageBoxView(containers: self.containers, selectedCustomizeImageIndex: self.$selectedCustomizeImageIndex, selectedImageGesture: self.$selectedImageGesture)
            }
            .background(Color.clear.opacity(0.1))
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
            .navigationBarItems(leading: HStack() {
                inputTextFieldView(containers: self.containers)
            }
            ,trailing:
                HStack(){
                    CustomizeButtonView(displayEditList: self.$displayEditList)
                    ImagePickerButton(showImagePicker: self.$showImagePicker)
                    ColorPickerView(selectedColor: self.$selectedColor, selectedCustomizeIndex: self.selectedCustomizeIndex, containers: self.containers)
                    NavigationLink(destination: FontSettingsView()) {
                        Image(systemName: "s.circle.fill")
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
    
    ///if conditional is true, then apply modifier to view
    ///.if(self.selectedCustomizeIndex == i ? true : false) {$0.RotationText(i: i, containers: self.containers)}
    //    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> TupleView<(Self?, Content?)> {
    //        if conditional { return TupleView((nil, content(self))) }
    //        else { return TupleView((self, nil)) }
    //    }
    
    func selectedAndCircle(containers:Container ,selectedCustomizeIndex:Int?) -> Bool {
        if selectedCustomizeIndex != nil {
            return containers.ls[selectedCustomizeIndex!].circleBool
        }
        return false
    }
    
}


struct SVGKFastImageViewSUI:UIViewRepresentable {
    @Binding var paramUrl:URL
    
    func makeUIView(context: Context) -> SVGKFastImageView {
        return SVGKFastImageView(svgkImage: SVGKImage())
        
    }
    
    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
        let result = paramUrl.startAccessingSecurityScopedResource()
        let exists = FileManager.default.fileExists(atPath: paramUrl.path)
        if exists {
            let img:SVGKImage = SVGKImage(contentsOf: paramUrl as URL)
            print(type(of: img))
            uiView.image = img
        }
        paramUrl.stopAccessingSecurityScopedResource()
    }
}
