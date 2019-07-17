//
//  EditProfileViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 11/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    var db : Firestore!
    
    var userfullname = ""
    var username = " "
    var imageData : UIImage!
    let CurrentUser =  Auth.auth().currentUser!.email!
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var fullNameText: UITextField!
    @IBOutlet weak var currencyText: UITextField!
    @IBOutlet weak var EmailIdText: UITextField!
    @IBOutlet weak var languageText: UITextField!
    
    @IBAction func changeImage(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func currencyOption(_ sender: UIButton) {
    }
    
    
    @IBAction func languageOption(_ sender: UIButton) {
    }
    
    
    @IBAction func doneEditing(_ sender: UIBarButtonItem) {
        update()
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameText.text = userfullname
        currencyText.text = "USD"
        languageText.text = "English"
        userProfileImage.image = imageData
    }
    func addImage(){
        let imageID = username
        let uploadRef = Storage.storage().reference(withPath: "uploads/\(imageID).jpg")
        guard let imageData = userProfileImage.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "uploads/jpeg"
        uploadRef.putData(imageData, metadata: uploadMetadata) { (uploadedMetadata, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else
            {
                print(uploadedMetadata!)
            }
        }
    }
    func update (){
        addImage()
    }
}
extension EditProfileViewController :   UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userProfileImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
