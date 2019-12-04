//
//  CameraVC.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 05/12/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

class CameraVC: UIViewController, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    class func showCameraAlert(ref : UIViewController, sender: UIButton){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { (_ alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async {
                ref.dismiss(animated: true, completion: nil)
                ref.perform(#selector(openCamera), with: nil, afterDelay: 0.0)
            }
        })
        
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default, handler: { (_ alert: UIAlertAction!) -> Void in
            DispatchQueue.main.async {
                ref.dismiss(animated: true, completion: nil)
                ref.perform(#selector(openGallery), with: nil, afterDelay: 0.0)
            }
        })
        
        alertController.addAction(takePhoto)
        alertController.addAction(choosePhoto)
        
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        ref.present(alertController, animated: false, completion: nil)
    }
    
    
    //Camera Button Action
      @objc func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
               DispatchQueue.main.async {
                   self.imagePicker.sourceType = .camera
                   self.imagePicker.delegate = self
                   self.imagePicker.allowsEditing = true
                   
                   self.imagePicker.modalPresentationStyle = .popover
                   self.present(self.imagePicker, animated: true, completion: nil)
                   
                   let imagePickerPopOverPresentationController = self.imagePicker.popoverPresentationController
                   imagePickerPopOverPresentationController?.permittedArrowDirections = .down
                   
                if UIDevice.current.userInterfaceIdiom == .pad {
                    //  self.imagePicker.popoverPresentationController?.sourceView = self.btnProfile.superview
                    //   self.imagePicker.popoverPresentationController?.sourceRect = self.btnProfile.frame
                    // self.imagePicker.popoverPresentationController?.permittedArrowDirections = [.down, .up]
                }
                
                  self.present(self.imagePicker, animated: true, completion: nil)
               }
           }
       }
    
    //Gallary Button Action
    @objc func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            DispatchQueue.main.async {
                
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = true
                
                self.imagePicker.modalPresentationStyle = .popover
                self.present(self.imagePicker, animated: true, completion: nil)
                
                let imagePickerPopOverPresentationController = self.imagePicker.popoverPresentationController
                imagePickerPopOverPresentationController?.permittedArrowDirections = .down
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    //  self.imagePicker.popoverPresentationController?.sourceView = self.btnProfile.superview
                    //   self.imagePicker.popoverPresentationController?.sourceRect = self.btnProfile.frame
                    // self.imagePicker.popoverPresentationController?.permittedArrowDirections = [.down, .up]
                }
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
}
// MARK: - UIImagePickerControllerDelegate
extension CameraVC : UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let profileImage = info[.originalImage] as? UIImage else {
            return
        }
        let dataImg: Data = profileImage.pngData()!
        Constant.defaults.set(dataImg, forKey: "UserProfileImg")
        Constant.defaults.synchronize()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
