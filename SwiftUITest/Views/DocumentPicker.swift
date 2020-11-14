//
//  DocumentPickerView.swift
//  SwiftUITest
//
//  Created by Mozes Vidami on 11/9/20.
//  Copyright © 2020 Mozes Vidami. All rights reserved.
//

import SwiftUI

struct DocumentPickerButton: View {
    
    @Binding var showFilePicker:Bool
    
    var body: some View {
        Button(action: {self.showFilePicker.toggle()}) {
            Text("ALMA")
        }
    }
    
    init(showFilePicker:Binding<Bool>) {
        self._showFilePicker = showFilePicker
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: [], in: .open)
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
}
