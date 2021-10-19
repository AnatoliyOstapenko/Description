//
//  ViewController.swift
//  Description
//
//  Created by MacBook on 09.10.2021.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {
    
    // initialize ManagerModel
    var managerModel = ManagerModel()
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        //activate Manager Delegate
        managerModel.managerDelegate = self
        
    }
    
    @IBAction func libraryBarButtonPressed(_ sender: UIBarButtonItem) {
        // activation method imagePickerController
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - CoreML method
    func identification(_ image: UIImage) {
        
        // add Core ML model
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(configuration: MLModelConfiguration()).model) else { return }
        
        // add request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            // get all results
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            // get first confident result
            guard let first = results.first?.identifier else { return }
            
            // show first confident result as bar title
            self.navigationItem.title = first
            
            // dispatch title
            self.managerModel.getTitle(first)
        }
        
        // convert UIImage to CIImage
        guard let ciImage = CIImage(image: image) else { return }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        
        //perform Vision framework
        do {
            try handler.perform([request])
        } catch { print(error.localizedDescription)}
        
        
        
    }
    

}
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get original image
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        // set image by default on the screen
        descriptionImage.image = image
        
        identification(image)
        
        // avoid freezing app
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
}

extension ViewController: ManagerDelegate {
    
    func updateData(_ extract: String) {
        
        DispatchQueue.main.async {
            
            self.descriptionLabel.text = extract
            
        }
        
    }
 
}

