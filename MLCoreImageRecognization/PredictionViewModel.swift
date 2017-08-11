//
//  PredictionViewModel.swift
//  MLCoreImageRecognization
//
//  Created by Danish Khan on 29/07/17.
//  Copyright © 2017 Danish Khan. All rights reserved.
//

import UIKit
import CoreML
import Vision

class PredictionViewModel: NSObject {
    
    //Mark: properties
    let vowels: [Character] = ["a", "e", "i", "o", "u"]
    
    func predictImageScene(image: CIImage, callback:@escaping (String) -> Void) {
        let model = self.getCoreMLModel()
        self.requestPrediction(model: model, imageToPredict: image) { (predictionMessage) in
            callback(predictionMessage)
        }
    }
    
    func getCoreMLModel() -> (VNCoreMLModel){
        guard let model = try? VNCoreMLModel(for: GoogLeNetPlaces().model)else {
            fatalError("Coundn't get the model")
        }
        return model
    }
    
    func requestPrediction(model: VNCoreMLModel, imageToPredict: CIImage, callback:@escaping (String) -> Void) {
        
        let request = VNCoreMLRequest(model: model) {request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first else {
                    fatalError("Unexpected result type form VNCoreMLRequest")
            }
            self.formatPredictionResult(results: topResult, callback: { (predictionMessage) in
                callback(predictionMessage)
            })
        }
        self.requestHandler(request: request, imageToPredict: imageToPredict)
    }
    
    func formatPredictionResult(results:VNClassificationObservation, callback:(String) -> Void){
        let article = (self.vowels.contains(results.identifier.first!)) ? "an" : "a"
        let predictionMessage = "\(Int(results.confidence * 100))% it's \(article) \(results.identifier)"
        callback(predictionMessage)
    }
    
    func requestHandler(request: VNCoreMLRequest, imageToPredict: CIImage) {
        let handler = VNImageRequestHandler(ciImage: imageToPredict)
        DispatchQueue.global(qos: .userInteractive).async {
            do{
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
        
    }

}
