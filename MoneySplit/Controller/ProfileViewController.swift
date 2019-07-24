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
    var activityIndicator  = UIActivityIndicatorView()

    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyLabel.text = UserDefaults.standard.string(forKey: "currency")
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = min(self.profileImageView.frame.width, self.profileImageView.frame.height) / 2.0
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currencyLabel.text = UserDefaults.standard.string(forKey: "currency")
        getData()
    }
   
    @IBAction func editProfile(_ sender: UIBarButtonItem) {
        
      if profileImageView.image == nil {
            let alert = UIAlertController(title: "Sorry!", message: "Please wait till your profile image is loading", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true , completion: nil)
        }
      else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as!  EditProfileViewController
            vc.userfullname = fullNameLabel.text!
            vc.imageData = profileImageView.image!
            vc.username = userNameLabel.text!
            navigationController?.pushViewController(vc, animated:true)
        }
    }
    
    @IBAction func Logoput(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        navigationController?.popToRootViewController(animated: true)
        UserDefaults.standard.set("false", forKey: "LogIn")
    }
    
    func getData(){
        activityIndicator.center = self.profileImageView.center
        activityIndicator.hidesWhenStopped = true
        self.activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
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
                        self.currencyLabel.text = UserDefaults.standard.string(forKey: "currency")
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
                                self.activityIndicator.stopAnimating()
                            }
                        }
                    }
                }
            }
        }
    }
}
