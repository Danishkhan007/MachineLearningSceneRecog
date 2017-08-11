//
//  ViewController.swift
//  MLCoreImageRecognization
//
//  Created by Danish Khan on 27/07/17.
//  Copyright © 2017 Danish Khan. All rights reserved.
//

import UIKit
import CoreML
import Vision

//MARK: - methods

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagePredictionLable: UILabel!
    
    // MARK: - Properties
    let vowels: [Character] = ["a", "e", "i", "o", "u"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage(tapGestureRecgonizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        guard let ciImage = CIImage(image: imageView.image!) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        
        detectScene(image: ciImage)
    }
    
    // MARK: - Image Prediction Method
    func detectScene(image: CIImage) {
        self.imagePredictionLable.text = "detecting scene...."
        let predictViewModelObj = PredictionViewModel()
        predictViewModelObj.predictImageScene(image: image) { (predictionMessage) in
            DispatchQueue.main.async { [weak self] in
                self?.imagePredictionLable.text = predictionMessage
                                }
        }
    }
    
    
    //image tapGestureRecognizer method
    @objc func pickImage(tapGestureRecgonizer: UITapGestureRecognizer) {
        let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .savedPhotosAlbum
            present(pickerController, animated: true)
        }
    
    //MARK: - ImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Coudn't load image from photos")
        }
        imageView.image = image
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("couldn't convert UIImage to CIImage")
        }
        detectScene(image: ciImage)
        dismiss (animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

