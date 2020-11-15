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
            Text("Doc")
        }
    }
    
    init(showFilePicker:Binding<Bool>) {
        self._showFilePicker = showFilePicker
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var url:URL
    
    func makeCoordinator() -> Coordinator {
        return DocumentPicker.Coordinator(parent1: self, url: $url)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent:DocumentPicker
        @Binding var url:URL
        
        init(parent1: DocumentPicker,url:Binding<URL>) {
            parent = parent1
            self._url = url
            
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            //print("URLS: ", urls.first?.path)
            self.url = urls.first!
        }
    }
    
}
