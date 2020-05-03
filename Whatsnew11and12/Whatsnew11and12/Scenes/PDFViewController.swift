//
//  PDFViewController.swift
//  Whatsnew11and12
//
//  Created by Jan Kaltoun on 19/11/2019.
//  Copyright © 2019 Jan Kaltoun. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    var pdfView: PDFView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        let printSelectionBtn = UIBarButtonItem(title: "Selection", style: .plain, target: self, action: #selector(printSelection))
        let nextPageBtn = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(nextPage))
        let previousPageBtn = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(previousPage))
        let firstPageBtn = UIBarButtonItem(title: "First", style: .plain, target: self, action: #selector(firstPage))
        let lastPageBtn = UIBarButtonItem(title: "Last", style: .plain, target: self, action: #selector(lastPage))

        navigationItem.rightBarButtonItems = [printSelectionBtn, lastPageBtn, firstPageBtn, nextPageBtn, previousPageBtn]

        // PDF
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        let url = Bundle.main.url(forResource: "SwiftUI", withExtension: "pdf")!
        pdfView.document = PDFDocument(url: url)
    }
    
    @objc func printSelection() {
        let text = pdfView.currentSelection?.string ?? ""
        
        let alert = UIAlertController(title: "You selected this", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome!", style: .default, handler: nil))
        present(alert, animated: true)
    }

    @objc func firstPage() {
        pdfView.goToFirstPage(nil)
    }

    @objc func lastPage() {
        pdfView.goToLastPage(nil)
    }
    
    @objc func nextPage() {
        pdfView.goToNextPage(nil)
    }

    @objc func previousPage() {
        pdfView.goToPreviousPage(nil)
    }
}

