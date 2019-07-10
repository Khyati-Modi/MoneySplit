//
//  ViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 08/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase


class LoginPageController: UIViewController {
   var gradientLayer: CAGradientLayer!
    var db: Firestore!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButtonOutlet: UIButton!
    @IBOutlet weak var forgotPasswordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignbackground()
        navigationController?.navigationBar.isHidden  = true
        
        //Do firebase setting
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        //Checking for userSession
        if UserDefaults.standard.bool(forKey: "LogIn") == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as!  TabBarViewController
            navigationController?.pushViewController(vc, animated:false)
        }
        
    }
    
    
    @IBAction func signUpClick(_ sender: UIButton) {
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signInClick(_ sender: UIButton) {
        
        db.collection("UserSignUp").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else  {
                for document in QuerySnapshot!.documents {
                    if self.userNameTextField.text == document.data()["userName"] as? String{
                        print(document.documentID)
                          let email = document.documentID
                        
                        Auth.auth().signIn(withEmail: "\(String(describing: email))", password: self.passwordTextField.text!) { (user, error) in
                            if let error = error {
                                print(error.localizedDescription)
                                return
                            }
                            
                            if user != nil{
                                print("user is logged in")
                                UserDefaults.standard.set(true, forKey: "LogIn")
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
  
    @IBAction func forgotPassword(_ sender: UITextField) {
        
    }
    
    
    func assignbackground(){
        //background and input text field style
        let background = UIImage(named: "bg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        let userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        let userImage = UIImage(named: "User")
        userImageView.contentMode = .scaleAspectFit
        userImageView.image = userImage
        userNameTextField.leftView = userImageView
        userNameTextField.leftViewMode = UITextField.ViewMode.always
        
        userNameTextField.autocorrectionType = .no
        userNameTextField.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: userNameTextField.frame.height - 1, width: userNameTextField.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.white.cgColor
        userNameTextField.borderStyle = UITextField.BorderStyle.none
        userNameTextField.layer.addSublayer(bottomLine)
        
        let passwordImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        passwordImageView.contentMode = .scaleAspectFit
        let passwordImage = UIImage(named: "Password")
        passwordImageView.image = passwordImage
        passwordTextField.leftView = passwordImageView
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        
        passwordTextField.borderStyle = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: passwordTextField.frame.height - 1, width: passwordTextField.frame.width, height: 1)
        bottomLine2.backgroundColor = UIColor.white.cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(bottomLine2)
        
        forgotPasswordOutlet.borderStyle = .none
        
        signInButtonOutlet.layer.backgroundColor = UIColor.white.cgColor
        signInButtonOutlet.layer.cornerRadius = 20
    }
    
}

