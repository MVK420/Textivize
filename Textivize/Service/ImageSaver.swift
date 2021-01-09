//
//  FileService.swift
//  Textivize
//
//  Created by Mozes Vidami on 1/9/21.
//

import SwiftUI

class ImageSaver: NSObject {
    
    @Binding var saveCompleteAlert:Bool
    @Binding var activeAlert:ActiveAlert
    
    init(saveCompleteAlert:Binding<Bool>,activeAlert:Binding<ActiveAlert>) {
        self._saveCompleteAlert = saveCompleteAlert
        self._activeAlert = activeAlert
    }
    
    func saveAsPNG(image:UIImage) {
        if let data = image.pngData() {
            print(data)
            let filename = getDocumentsDirectory().appendingPathComponent("textivize.png")
            _ = filename.startAccessingSecurityScopedResource()
            do {
                try data.write(to: filename)
                self.saveSuccessful()
            } catch {
                Swift.print(error)
            }
            filename.stopAccessingSecurityScopedResource()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    func saveSuccessful() {
        print("YO")
        sleep(1)
        print("YO")
        activeAlert = .second
        saveCompleteAlert.toggle()
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        self.saveSuccessful()
    }
}

///For Hiding
struct ParentFunctionKey: EnvironmentKey {
    static let defaultValue: (() -> Void)? = nil
}

extension EnvironmentValues {
    var parrentFunc: (() -> Void)? {
        get { self[ParentFunctionKey.self] }
        set { self[ParentFunctionKey.self] = newValue }
    }
}
