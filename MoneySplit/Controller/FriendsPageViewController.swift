//
//  FriendsPageViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 10/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class FriendsPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    var db : Firestore!
    var selectedUserName : String!
    var userImage : UIImage?
    var amount : Double!
    var colour : String!
    
    var billArray = [BillHistory]()
    
    let greenColor = UIColor(red:0.32, green:0.60, blue:0.33, alpha:1.0)
    let pinkColor = UIColor(red:0.98, green:0.30, blue:0.38, alpha:1.0)
    
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var profileAmountLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!

    @IBAction func Backbutton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(colour)
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        getdata()
        
        profileImage.image = userImage
        profileImage.clipsToBounds = true
        
        profileImage.layer.borderWidth = 1.5
        
        if colour == "green" {
            profileImage.layer.borderColor = greenColor.cgColor
            userFullName.textColor = greenColor
            profileAmountLabel.textColor = greenColor
            profileAmountLabel.text = "You Owe 0 $"

        }
        else {
            profileImage.layer.borderColor = pinkColor.cgColor
            userFullName.textColor = pinkColor
            profileAmountLabel.textColor = pinkColor
            profileAmountLabel.text = "You Owe \(amount!) $"

        }
        
        userFullName.font = UIFont(name: "Poppins", size: 28)
        profileAmountLabel.font = UIFont(name: "Poppins", size: 21)
        userFullName.text = selectedUserName
        
        profileImage.layer.cornerRadius = min(self.profileImage.frame.width, self.profileImage.frame.height) / 2.0
        historyTable.delegate = self
        historyTable.dataSource = self
        
        historyTable.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")

    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(billArray.count)
        print(billArray[0].subjectOfBill)
        
        let FriendTableViewCell = historyTable.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
     
        FriendTableViewCell.subjectLabel.text = (billArray[indexPath.row].subjectOfBill)
        FriendTableViewCell.paidByLabel.text = ("\(billArray[indexPath.row].paidBy!) paid  \(billArray[indexPath.row].totalAmount!)$")
        print(FriendTableViewCell.subjectLabel)
        return FriendTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BillDataViewController") as! BillDataViewController
        vc.selectedItem = (billArray[indexPath.row].subjectOfBill)
        vc.paidByUser = (billArray[indexPath.row].paidBy!)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    func getdata() {
        DispatchQueue.main.async {
            self.billArray.removeAll()
            
            
            self.db.collection("PeopleWhoOweYou").getDocuments{ (QuerySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                else {
                    let billInfo = BillHistory()
                    for document in QuerySnapshot!.documents {

                        billInfo.subjectOfBill = document.data()["Subject"] as? String
                        
                        let emailId = document.data()["paidBy"] as! String
                        
                        self.db.collection("UserSignUp").getDocuments(completion: { (QuerySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            }
                            else {
                                var fullName = ""
                                
                                for document in QuerySnapshot!.documents {
                                    if emailId == document.documentID {
                                        fullName = (document.data()["userName"] as? String)!
                                        self.historyTable.reloadData()
                                    }
                                }
                                billInfo.paidBy = fullName
                                let countTwo = (document.data()["totalAmount"] as! String)
                                billInfo.totalAmount = (countTwo as NSString).doubleValue
                               
                            }
                            self.historyTable.reloadData()
                        })
                    }
                    self.billArray.append(billInfo)
                }
            }
        }
    }
}
