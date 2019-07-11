//
//  FriendsPageViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 10/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class FriendsPageViewController: UIViewController {
    var db : Firestore!
    var selectedUserName : String!
    var userImage : UIImage?
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!

    @IBAction func Backbutton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userFullName.text = selectedUserName
            profileImage.image = userImage
    }
    
}
