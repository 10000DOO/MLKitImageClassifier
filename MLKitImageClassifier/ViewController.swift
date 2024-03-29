//
//  ViewController.swift
//  MLKitImageClassifier
//
//  Created by 이건준 on 2/25/24.
//

import UIKit
import MLKitVision
import MLKitImageLabeling

class ViewController: UIViewController {
    
    @IBOutlet weak var output: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func doInference(_ sender: Any) {
        getLabels(with: imageView.image!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "2")
    }
    
    // This is called when the user presses the button
    func getLabels(with image: UIImage){
        // Get the image from the UI Image element and set its orientation
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        // Create Image Labeler options, and set the threshold to 0.4
        // so we will ignore all classes with a probability of 0.4 or less
        let options = ImageLabelerOptions()
        options.confidenceThreshold = 0.4
        
        // Initialize the labeler with these options
        let labeler = ImageLabeler.imageLabeler(options: options)
        
        // And then process the image, with the callback going to self.processresult
        labeler.process(visionImage) { labels, error in
            self.processResult(from: labels, error: error)
        }
    }
    
    // This gets called by the labeler's callback
    func processResult(from labels: [ImageLabel]?, error: Error?){
        // String to hold the labels
        var labeltexts = ""
        // Check that we have valid labels first
        guard let labels = labels else{
            return
        }
        // ...and if we do we can iterate through the set to get the description and confidence
        for label in labels{
            let labelText = label.text + " : " + label.confidence.description + "\n"
            labeltexts += labelText
        }
        // And when we're done we can update the UI with the list of labels
        output.text = labeltexts
    }
}

