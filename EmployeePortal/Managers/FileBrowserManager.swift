//
//  FileBrowserManager.swift
//  EmployeePortal
//
//  Created by Sajeev on 1/13/20.
//  Copyright © 2020 EmployeePortal. All rights reserved.
//

import Foundation
import FileBrowser
import MobileCoreServices

class FileBrowserManager: UIViewController {
    
    typealias FileCompletionHandler = (_ fileUrl: URL) -> Void
    var fileCompletion: FileCompletionHandler? = nil
    
    // singleton
    static let shared = FileBrowserManager()
    
    let fileBrowser = FileBrowser()
    
    func pickFile(viewController: UIViewController, completion: FileCompletionHandler? = nil) {
        fileCompletion = completion
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        viewController.present(documentPicker, animated: true)
    }
    
}

extension FileBrowserManager: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true) { [weak self] in
            self?.fileCompletion?(urls.first!)
        }
    }
}

