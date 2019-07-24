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
                let alert = UIAlertController(title: "Oops!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true , completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Successfull!", message: "Please Check your mailBox for further procedure", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .cancel, handler: { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(action)
                self.present(alert, animated: true , completion: nil)
            }
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBackground()
    }
    
    func getBackground(){
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "bg")
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        let emailImageView = UIImageView(frame: CGRect(x: 2, y: 0, width: 60, height: 22))
        emailImageView.contentMode = .scaleAspectFit
        let emailImage = UIImage(named: "Email")
        emailImageView.image = emailImage
        emailField.leftView = emailImageView
        emailField.leftViewMode = UITextField.ViewMode.always
        emailField.attributedPlaceholder = NSAttributedString(string: "Enter Your Registered EmailID", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        emailField.autocorrectionType = .no
        emailField.borderStyle = .none
        let bLine = CALayer()
        bLine.frame = CGRect(x: 0, y: emailField.frame.height - 1, width: emailField.frame.width, height: 1)
        bLine.backgroundColor = UIColor.white.cgColor
        emailField.borderStyle = UITextField.BorderStyle.none
        emailField.layer.addSublayer(bLine)
        
        reserPassword.layer.backgroundColor = UIColor.white.cgColor
        reserPassword.layer.cornerRadius = 30
        }
}
