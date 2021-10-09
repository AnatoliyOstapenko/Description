//
//  ViewController.swift
//  Description
//
//  Created by MacBook on 09.10.2021.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
    }

    
    @IBAction func libraryBarButtonPressed(_ sender: UIBarButtonItem) {
        // activation method imagePickerController
        present(imagePicker, animated: true, completion: nil)
    }
    

}
// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // get original image
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        // set image by default on the screen
        descriptionImage.image = image
        
        // avoid freezing app
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
}

