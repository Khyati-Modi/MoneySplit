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
    var userPickerView : UIPickerView!
    var currencyArray : [String] = ["USD","INR"]
    var selectedCurrency : Int!
    var selectedCurrencyRow : Int = 0


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
        self.userPickerView = UIPickerView(frame:CGRect(x: 0, y: 450, width: currencyText.frame.width , height: 150))
        self.userPickerView.delegate = self
        self.userPickerView.dataSource = self
        self.userPickerView.backgroundColor = UIColor.white
        self.userPickerView.selectRow(selectedCurrencyRow, inComponent: 0, animated: true)
        self.view.addSubview(userPickerView)
    }
    
    @IBAction func languageOption(_ sender: UIButton) {
    }
    
    
    @IBAction func doneEditing(_ sender: UIBarButtonItem) {
        print(currencyText.text!)
        UserDefaults.standard.setValue(currencyText.text!, forKey: "currency")
        updateImage()
        updateFullName()
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameText.text = userfullname
        currencyText.text = UserDefaults.standard.string(forKey: "currency")
        languageText.text = "English"
        userProfileImage.image = imageData
    }
    
    func updateImage(){
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
    
    func updateFullName() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser?.email
        
        
        let docData: [String: Any] = ["fullName": "\(fullNameText.text!)","email": "\(currentUser!)","userName": "\(username)"]
        
        db.collection("UserSignUp").document(currentUser!).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

extension EditProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = row
        currencyText.text = currencyArray[row]
        selectedCurrencyRow = row
        userPickerView.isHidden = true
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
