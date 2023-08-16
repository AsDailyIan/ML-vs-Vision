//
//  ComparisonUI.swift
//  OCR_Comparison
//
//  Created by 傅遠義 on 2023/8/11.
//

import SwiftUI
import UIKit

struct OCRResult: Identifiable {
    var id: String
    var time: String
    var detectString: String
}

struct OCRSummary {
    var totalTime = 0.0
    var avarageTime = 0.0
    var count = 0.0
}

struct OCRComparisonView: View {
    @State private var results: [OCRResult] = []
    @State private var MLKitsummary: OCRSummary = OCRSummary()
    @State private var VisionKitsummary: OCRSummary = OCRSummary()
    
    var body: some View {
        VStack{
            Group{
                Text("Summary")
                    .bold()
                Text("ML Kit total Time: \(MLKitsummary.totalTime)")
                Text("Vision Kit total Time: \(VisionKitsummary.totalTime)")
                Text("ML Kit average Time: \(MLKitsummary.avarageTime)")
                Text("Vision Kit average Time: \(VisionKitsummary.avarageTime)")
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .padding(.horizontal, 0)
            
            List(results) { result in
                Image(result.id)
                    .resizable()
                    .scaledToFit()
                Text(result.time)
                Text(result.detectString)
            }
            .onAppear(perform: loadImage)
        }
    }
    
    func loadImage() {
        for i in 1...10 {
            let idString = "00_" + String(format: "%02d", i)
            if let image = UIImage(named: idString) {
                comparePerformance(uiImage: image) { timeResult, detectResult in
                    DispatchQueue.main.async {
                        results.append(OCRResult(id: idString, time: timeResult, detectString: detectResult))
                    }
                }
            }
        }
    }
    
    func comparePerformance(uiImage: UIImage, completion: @escaping (String, String) -> Void) {
        recognizeTextUsingMLKit(image: uiImage) { mlKitTime, mlKitResultString in
            print("ML Kit took \(mlKitTime) seconds")

            recognizeTextUsingVisionKit(image: uiImage) { visionKitTime, visionKitResultString in
                print("Vision Kit took \(visionKitTime) seconds")
                
                MLKitsummary.count += 1
                MLKitsummary.totalTime += mlKitTime
                MLKitsummary.avarageTime = MLKitsummary.totalTime / MLKitsummary.count
                VisionKitsummary.count += 1
                VisionKitsummary.totalTime += visionKitTime
                VisionKitsummary.avarageTime = VisionKitsummary.totalTime / VisionKitsummary.count
                

                var result = ""
                var detectResult = "ML Kit Text Result:\n \(mlKitResultString)\n\n"
                detectResult += "\nVision Kit Text Result:\n \(visionKitResultString)"

                if mlKitTime < visionKitTime {
                    result = "ML Kit is faster for image"
                } else if mlKitTime > visionKitTime {
                    result = "Vision Kit is faster for image"
                } else {
                    result = "Both took the same time for image"
                }
                result += ", ML Kit took \(mlKitTime) seconds, Vision Kit took \(visionKitTime) seconds"

                completion(result, detectResult)
            }
        }
    }
}

struct OCRComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        OCRComparisonView()
    }
}

