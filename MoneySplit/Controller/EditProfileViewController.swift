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
//    var username : String!
    var username = ""
    var userfullname = ""
    let CurrentUser =  Auth.auth().currentUser!.email!
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userFullName: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var EmailIdText: UITextField!
    @IBOutlet weak var languageText: UITextField!

    @IBAction func doneEditing(_ sender: UIBarButtonItem) {
        update()
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      print(CurrentUser)
        userFullName.text = userfullname
        usernameText.text = username
        EmailIdText.text = CurrentUser
        languageText.text = "English"
        print(userFullName.text!)
    }
    func update (){
        db.collection("UserSignUp").document(CurrentUser).updateData([
            "fullName": userFullName.text!,
            "email": EmailIdText.text!,
            "userName": usernameText.text!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    
            
    }
}