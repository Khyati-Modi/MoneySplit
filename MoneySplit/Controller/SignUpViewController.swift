//
//  SignUpViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 08/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var db: Firestore!
    let actionCodeSettings = ActionCodeSettings()

    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddImage(_ sender: UIButton) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
    }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.dismiss(animated: true, completion: nil)
        }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setBackground()
        //Do firebase setting
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
      
        actionCodeSettings.url = URL(string: "https://khyatimodi.page.link")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
    
    }
    func setBackground(){
        // Background Image and input text field style
        let background = UIImage(named: "SignUpBg")
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.image = background
        self.view.sendSubviewToBack(imageView)
        
        navigationController?.navigationBar.isHidden = true
        signUpButton.layer.cornerRadius = 25
        
        
        let userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        let userImage = UIImage(named: "User")
        userImageView.contentMode = .scaleAspectFit
        userImageView.image = userImage
        usernameTextField.leftView = userImageView
        usernameTextField.leftViewMode = UITextField.ViewMode.always
        
        usernameTextField.autocorrectionType = .no
        usernameTextField.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: usernameTextField.frame.height - 1, width: usernameTextField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        usernameTextField.borderStyle = UITextField.BorderStyle.none
        usernameTextField.layer.addSublayer(bottomLine)
        
        let fullNameIamgeView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        fullNameIamgeView.contentMode = .scaleAspectFit
        let fullNameImage = UIImage(named: "User")
        fullNameIamgeView.image = fullNameImage
        fullnameTextField.leftView = fullNameIamgeView
        fullnameTextField.leftViewMode = UITextField.ViewMode.always
        
        fullnameTextField.autocorrectionType = .no
        fullnameTextField.borderStyle = .none
        let bsLine = CALayer()
        bsLine.frame = CGRect(x: 0, y: fullnameTextField.frame.height - 1, width: fullnameTextField.frame.width, height: 1)
        bsLine.backgroundColor = UIColor.black.cgColor
        fullnameTextField.borderStyle = UITextField.BorderStyle.none
        fullnameTextField.layer.addSublayer(bsLine)
        
        let emailImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        emailImageView.contentMode = .scaleAspectFit
        let emailImage = UIImage(named: "Email")
        emailImageView.image = emailImage
        emailTextField.leftView = emailImageView
        emailTextField.leftViewMode = UITextField.ViewMode.always
        
        emailTextField.autocorrectionType = .no
        emailTextField.borderStyle = .none
        let bLine = CALayer()
        bLine.frame = CGRect(x: 0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 1)
        bLine.backgroundColor = UIColor.black.cgColor
        emailTextField.borderStyle = UITextField.BorderStyle.none
        emailTextField.layer.addSublayer(bLine)
        
        let passwordImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        passwordImageView.contentMode = .scaleAspectFit
        let passwordImage = UIImage(named: "Password")
        passwordImageView.image = passwordImage
        passwordTextField.leftView = passwordImageView
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        
        passwordTextField.autocorrectionType = .no
        passwordTextField.borderStyle = .none
        let btmLine = CALayer()
        btmLine.frame = CGRect(x: 0, y: passwordTextField.frame.height - 1, width: passwordTextField.frame.width, height: 1)
        btmLine.backgroundColor = UIColor.black.cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(btmLine)
    }
    
    @IBAction func SignUpClick(_ sender: UIButton) {
        addUser()
        addImage()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func addUser() {
        let email = emailTextField.text!
        
        let docData: [String: Any] = ["fullName": "\(fullnameTextField.text!)","email": "\(emailTextField.text!)","userName": "\(usernameTextField.text!)"]
        
        db.collection("UserSignUp").document("\(email)").setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func addImage(){
        let imageID = usernameTextField.text!
        let uploadRef = Storage.storage().reference(withPath: "uploads/\(imageID).jpg")
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.75) else { return }
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
   
    
    
    
//    func addCaption() {
//        let text = postText.text!
//        var ref: DocumentReference? = nil
//        let newItem = UserInfo()
//        ref = db.collection("createPost").addDocument( data: ["Caption": "\(text)"]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
//        newItem.postId = ref!.documentID
//        newItem.postCaption = text
//
//        self.setId = ref!.documentID
//        print("Document added with ID: \(ref!.documentID)")
//        print(self.setId)
//    }
//
    
}
