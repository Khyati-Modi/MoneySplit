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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var conditionView: UIImageView!
    @IBOutlet weak var signUpOutlet: UIButton!
    
    let greenColour = UIColor(red:0.32, green:0.60, blue:0.33, alpha:1.0)

    
    @IBAction func tAcButtonClick(_ sender: UIButton) {
        if  conditionView.image == UIImage(named: "Ellipse") {
             conditionView.image = UIImage(named: "tick")
        }
        else{
            conditionView.image = UIImage(named: "Ellipse")
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddImage(_ sender: UIButton) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func SignUpClick(_ sender: UIButton) {
        if usernameTextField.text == ""{
            let alert = UIAlertController(title: "", message: "Enter Your UserName", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true , completion: nil)
            
        }
        if fullnameTextField.text == ""{
            let alert = UIAlertController(title: "", message: "Enter Your Full Name", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true , completion: nil)
        }
        if emailTextField.text == ""{
            let alert = UIAlertController(title: "", message: "Enter Your EmailId", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true , completion: nil)
        }
        if passwordTextField.text == ""{
            let alert = UIAlertController(title: "", message: "Enter Your Password", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true , completion: nil)
        }
        if conditionView.image == UIImage(named: "Ellipse"){
            let alert = UIAlertController(title: "", message: "Please agree with our terms and conditions", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true , completion: nil)
        }

        if usernameTextField.text != "" && fullnameTextField.text != "" && emailTextField.text != "" && passwordTextField.text != "" && conditionView.image == UIImage(named: "tick") {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
               
                if let error = error {
                    let alert = UIAlertController(title: "Oops!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true , completion: nil)
                }
                
                if user != nil{
                    self.addUser()
                    self.addImage()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        //Do firebase setting
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        self.navigationController?.navigationBar.isHidden = true
        
        actionCodeSettings.url = URL(string: "https://moneySplit.page.link")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
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
    
    func setBackground(){
        // Background Image and input text field style
        let background = UIImage(named: "SignUpBg")
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.image = background
        self.view.sendSubviewToBack(imageView)
        
        signUpOutlet.layer.cornerRadius = 26
        signUpOutlet.backgroundColor = greenColour

        
        conditionView.image = UIImage(named: "Ellipse")
        conditionView.contentMode = .scaleAspectFit
        
        let userImageView = UIImageView(frame: CGRect(x: 2, y: 0, width: 60, height: 22))
        let userImage = UIImage(named: "signUser")
        userImageView.contentMode = .scaleAspectFit
        userImageView.image = userImage
        usernameTextField.leftView = userImageView
        usernameTextField.leftViewMode = UITextField.ViewMode.always
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "userName", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        usernameTextField.autocorrectionType = .no
        usernameTextField.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: usernameTextField.frame.height - 1, width: usernameTextField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        usernameTextField.borderStyle = UITextField.BorderStyle.none
        usernameTextField.layer.addSublayer(bottomLine)
        
        let fullNameIamgeView = UIImageView(frame: CGRect(x: 2, y: 0, width: 60, height: 22))
        fullNameIamgeView.contentMode = .scaleAspectFit
        let fullNameImage = UIImage(named: "signUser")
        fullNameIamgeView.image = fullNameImage
        fullnameTextField.leftView = fullNameIamgeView
        fullnameTextField.leftViewMode = UITextField.ViewMode.always
        fullnameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])

        
        fullnameTextField.autocorrectionType = .no
        fullnameTextField.borderStyle = .none
        let bsLine = CALayer()
        bsLine.frame = CGRect(x: 0, y: fullnameTextField.frame.height - 1, width: fullnameTextField.frame.width, height: 1)
        bsLine.backgroundColor = UIColor.gray.cgColor
        fullnameTextField.borderStyle = UITextField.BorderStyle.none
        fullnameTextField.layer.addSublayer(bsLine)
        
        let emailImageView = UIImageView(frame: CGRect(x: 2, y: 0, width: 60, height: 22))
        emailImageView.contentMode = .scaleAspectFit
        let emailImage = UIImage(named: "Email")
        emailImageView.image = emailImage
        emailTextField.leftView = emailImageView
        emailTextField.leftViewMode = UITextField.ViewMode.always
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])

        
        emailTextField.autocorrectionType = .no
        emailTextField.borderStyle = .none
        let bLine = CALayer()
        bLine.frame = CGRect(x: 0, y: emailTextField.frame.height - 1, width: emailTextField.frame.width, height: 1)
        bLine.backgroundColor = UIColor.gray.cgColor
        emailTextField.borderStyle = UITextField.BorderStyle.none
        emailTextField.layer.addSublayer(bLine)
        
        let passwordImageView = UIImageView(frame: CGRect(x: 2, y: 0, width: 60, height: 22))
        passwordImageView.contentMode = .scaleAspectFit
        let passwordImage = UIImage(named: "signPassword")
        passwordImageView.image = passwordImage
        passwordTextField.leftView = passwordImageView
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])

        
        passwordTextField.autocorrectionType = .no
        passwordTextField.borderStyle = .none
        let btmLine = CALayer()
        btmLine.frame = CGRect(x: 0, y: passwordTextField.frame.height - 1, width: passwordTextField.frame.width, height: 1)
        btmLine.backgroundColor = UIColor.gray.cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(btmLine)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
