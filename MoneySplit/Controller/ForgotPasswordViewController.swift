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
                self.present(alert, animated: true , completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getBackground(){
    
        let background = UIImage(named: "bg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        reserPassword.layer.backgroundColor = UIColor.white.cgColor
        reserPassword.layer.cornerRadius = 30
        }
}
