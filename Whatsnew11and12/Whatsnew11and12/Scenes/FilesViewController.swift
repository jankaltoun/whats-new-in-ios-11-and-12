//
//  FilesViewController.swift
//  Whatsnew11and12
//
//  Created by Jan Kaltoun on 20/11/2019.
//  Copyright © 2019 Jan Kaltoun. All rights reserved.
//

import UIKit
import MobileCoreServices

class FilesViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func chooseFile(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(
            documentTypes: [kUTTypeImage as String],
            in: UIDocumentPickerMode.import
        )
        
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func showBrowser(_ sender: Any) {
        let documentBrowser = UIDocumentBrowserViewController(
            forOpeningFilesWithContentTypes: [kUTTypeImage as String]
        )
        
        documentBrowser.modalPresentationStyle = .fullScreen
        
        self.present(documentBrowser, animated: true, completion: nil)
    }
}

extension FilesViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard controller.documentPickerMode == UIDocumentPickerMode.import else {
            return
        }
        
        let data = try! Data(contentsOf: urls.first!)
        let image = UIImage(data: data)
        
        imageView.image = image
    }
}
