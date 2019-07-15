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
    
    var billArray = [BillHistory]()
    
    
    let greenColour = UIColor(red:0.32, green:0.60, blue:0.33, alpha:1.0)
    let pinkColour = UIColor(red:0.98, green:0.30, blue:0.38, alpha:1.0)

    
    @IBOutlet weak var historyTable: UITableView!
    
    @IBOutlet weak var profileAmountLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!

    @IBAction func Backbutton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userFullName.text = selectedUserName
        profileImage.image = userImage
        profileImage.clipsToBounds = true
        
        profileImage.layer.borderWidth = 1.5
        profileImage.layer.borderColor = UIColor.red.cgColor
        
        userFullName.font = UIFont(name: "Poppins", size: 28)
        profileAmountLabel.font = UIFont(name: "Poppins", size: 21)
        
        userFullName.textColor = greenColour
        
        profileImage.layer.cornerRadius = min(self.profileImage.frame.width, self.profileImage.frame.height) / 2.0
        historyTable.delegate = self
        historyTable.dataSource = self
        
        historyTable.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")

        getdata()
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//      let   currentMonth = Calendar.current.
//        return currentMonth.count
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(billArray.count)
        print(billArray[0].subjectOfBill)
        
        let FriendTableViewCell = historyTable.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
     
        FriendTableViewCell.subjectLabel.text = (billArray[indexPath.row].subjectOfBill)
        FriendTableViewCell.paidByLabel.text = (billArray[indexPath.row].paidBy!)
        print(FriendTableViewCell.subjectLabel)
        return FriendTableViewCell
    }
    
    
    func getdata(){
        self.billArray.removeAll()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        db.collection("PeopleWhoOweYou").getDocuments(completion: { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else{
                let billInfo = BillHistory()
                for document in QuerySnapshot!.documents {
                    billInfo.subjectOfBill = document.data()["Subject"] as? String
                    billInfo.paidBy = document.data()["paidBy"] as? String
                    self.billArray.append(billInfo)
                    self.historyTable.reloadData()
                }
            }
            self.historyTable.reloadData()
        })
    }
}
