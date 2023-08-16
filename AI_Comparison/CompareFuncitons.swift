//
//  ViewController.swift
//  OCR_Comparison
//
//  Created by 傅遠義 on 2023/8/9.
//


import Vision
import MLKitVision
import MLKitTextRecognition
import SwiftUI

func recognizeTextUsingMLKit(image: UIImage, completion: @escaping (Double, String) -> Void) {
    let visionImage = VisionImage(image: image)
    visionImage.orientation = image.imageOrientation
    let options = TextRecognizerOptions()
    let textRecognizer = TextRecognizer.textRecognizer(options: options)
    
    let startTime = CFAbsoluteTimeGetCurrent()

    textRecognizer.process(visionImage) { result, error in
        guard error == nil, let result = result else {
            print("Error processing image with MLKit: \(error!.localizedDescription)")
            return
        }
        
        let timeElapsedMLKit = CFAbsoluteTimeGetCurrent() - startTime
        print("MLKit took \(timeElapsedMLKit) seconds for image.")
        
        completion(timeElapsedMLKit, result.text)  // Call the completion handler with the elapsed time
    }
}

func recognizeTextUsingVisionKit(image: UIImage, completion: @escaping (Double, String) -> Void) {
    guard let img = image.cgImage else {
        fatalError("Missing image to scan")
    }
    
    let startTime = CFAbsoluteTimeGetCurrent()

    let request = VNRecognizeTextRequest { request, error in
        guard let observations = request.results as? [VNRecognizedTextObservation] else {
            fatalError("Received invalid observations")
        }
        
        let text =  observations.compactMap({
            $0.topCandidates(1).first?.string
        }).joined(separator: ", ")
        
        let timeElapsedVisionKit = CFAbsoluteTimeGetCurrent() - startTime
        print("VisionKit took \(timeElapsedVisionKit) seconds for image.")
        
        completion(timeElapsedVisionKit, text)  // Call the completion handler with the elapsed time
    }
    
    let requests = [request]
    DispatchQueue.global(qos: .userInitiated).async {
        let handler = VNImageRequestHandler(cgImage: img, options: [:])
        try? handler.perform(requests)
    }
}
