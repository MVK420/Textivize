//
//  DocumentPicker.swift
//  Textivize
//
//  Created by Mozes Vidami on 1/9/21.
//

import SwiftUI
import SVGKit

struct DocumentPicker: UIViewControllerRepresentable {
    
    private let onSVGImagePicked: (SVGKImage) -> Void
    
    public init(onSVGImagePicked: @escaping (SVGKImage) -> Void) {
        self.onSVGImagePicked = onSVGImagePicked
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            //onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            parent1: self, onSVGImagePicked: self.onSVGImagePicked
        )
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
        private let onSVGImagePicked: (SVGKImage) -> Void
        
        init(parent1: DocumentPicker, onSVGImagePicked: @escaping (SVGKImage) -> Void) {
            parent = parent1
            self.onSVGImagePicked = onSVGImagePicked
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let url = urls.first!
            _ = url.startAccessingSecurityScopedResource()
            let exists = FileManager.default.fileExists(atPath: url.path)
            if exists {
                if let img:SVGKImage = SVGKImage(contentsOf: url as URL) {
                    self.onSVGImagePicked(img)
                }
            }
            url.stopAccessingSecurityScopedResource()
        }
    }
}
