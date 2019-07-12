//
//  ProfileViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 09/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    var db: Firestore!

    
    
    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = min(self.profileImageView.frame.width, self.profileImageView.frame.height) / 2.0
        getData()
    }
    
    @IBAction func editProfile(_ sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as!  EditProfileViewController
        vc.username = userNameLabel.text!
        vc.userfullname = fullNameLabel.text!
        navigationController?.pushViewController(vc, animated:true)
    }
    
    @IBAction func Logoput(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        navigationController?.popViewController(animated: true)
        UserDefaults.standard.set("false", forKey: "LogIn")

    }
    
    func getData(){
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.collection("UserSignUp").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else  {
                for document in QuerySnapshot!.documents {
                    if Auth.auth().currentUser?.email! == document.documentID {
                        self.fullNameLabel.text = document.data()["fullName"] as? String
                        self.emailIdLabel.text = document.data()["email"] as? String
                        self.userNameLabel.text = document.data()["userName"] as? String
                        self.currencyLabel.text = "USD"
                        self.languageLabel.text = "English"
                        
                        let imageFileName = document.data()["userName"] as! String
                        
                        let storageRef = Storage.storage().reference(withPath: "uploads/\(imageFileName).jpg")
                        storageRef.getData(maxSize: 4 * 1024 * 1024){(data, error) in
                            if let error = error {
                                print("\(error)")
                                return
                            }
                            if let data = data {
                                self.profileImageView.image = UIImage(data: data)!

                                print("File Downloaded")
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
}
