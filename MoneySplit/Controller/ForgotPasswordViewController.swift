//
//  ForgotPasswordViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 17/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var reserPassword: UIButton!
    
    @IBAction func resetPassword(_ sender: UIButton) {
        
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { error in
            if let error = error {
                print(error.localizedDescription)
                
                let alert = UIAlertController(title: "Oops!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true , completion: nil)
            }
            else{
                
                let alert = UIAlertController(title: "Successfull!", message: "Please Check your mailBox for further procedure", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(action)
                self.navigationController?.popViewController(animated: true)
                self.present(alert, animated: true , completion: nil)
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getBackground(){
    
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
        
//        let userImageView = UIImageView(frame: CGRect(x: 05, y: 0, width: 60, height: 22))
//        let userImage = UIImage(named: "Email")
//        userImageView.contentMode = .scaleAspectFit
//        userImageView.image = userImage
//        emailField.leftView = userImageView
//        emailField.leftViewMode = UITextField.ViewMode.always
//        emailField.attributedPlaceholder = NSAttributedString(string: "EmailId", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        
//        emailField.autocorrectionType = .no
//        emailField.borderStyle = .none
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 0, y: emailField.frame.height - 1, width: emailField.frame.width, height: 1)
//        bottomLine.backgroundColor = UIColor.white.cgColor
//        emailField.borderStyle = UITextField.BorderStyle.none
//        emailField.layer.addSublayer(bottomLine)
        
//        let passwordImageView = UIImageView(frame: CGRect(x: 05, y: 0, width: 60, height: 22))
       
        reserPassword.layer.backgroundColor = UIColor.white.cgColor
        reserPassword.layer.cornerRadius = 30
        }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
