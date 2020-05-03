//
//  VisionViewController.swift
//  Whatsnew11and12
//
//  Created by Jan Kaltoun on 19/11/2019.
//  Copyright © 2019 Jan Kaltoun. All rights reserved.
//

import UIKit
import Vision

class VisionViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    let image = UIImage(named: "license")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detectText()
    }
    
    func detectText() {
        // Prepare request
        let request = VNRecognizeTextRequest { request, error in
            var texts = [VNRecognizedText]()
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                fatalError("Received invalid observations")
            }

            for observation in observations {
                guard let bestCandidate = observation.topCandidates(1).first else {
                    print("No candidate")
                    continue
                }

                print(bestCandidate.string)
                
                texts.append(bestCandidate)
            }
            
            DispatchQueue.main.async {
                self.imageView.image = self.drawRectangles(texts: texts)
            }
        }
        request.recognitionLevel = .accurate
        
        // Run request
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: self.image.cgImage!, options: [:])
            try? handler.perform([request])
        }
    }
    
    func drawRectangles(texts: [VNRecognizedText]) -> UIImage {
        let imageSize = image.size
        let bounds = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
        let format = image.imageRendererFormat
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(
            bounds: bounds,
            format: format
        )
        
        return renderer.image { context in
            context.cgContext.setLineWidth(0.75)
            context.cgContext.setStrokeColor(UIColor.red.cgColor)
            
            image.draw(at: .zero)
            
            for text in texts {
                guard let boundingBox = try? text.boundingBox(for: text.string.startIndex ..< text.string.endIndex) else {
                    continue
                }
                
                let rectangle = CGRect(
                    x: (boundingBox.topLeft.x) * imageSize.width,
                    y: (1 - boundingBox.topLeft.y) * imageSize.height,
                    width: boundingBox.topRight.x * imageSize.width - boundingBox.topLeft.x * imageSize.width,
                    height: (1 - boundingBox.bottomLeft.y) * imageSize.height - (1 - boundingBox.topLeft.y) * imageSize.height
                )
                
                context.stroke(rectangle)
            }
        }
    }
}


