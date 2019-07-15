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

    var infoArray = ["Khyati","Dharmik","Saheb"]
    
    
    
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
        historyTable.delegate = self
        historyTable.dataSource = self
        
        historyTable.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")

        getdata()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(billArray.count)
        print(billArray[0].subjectOfBill)
        

        let cell = historyTable.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
     
        cell.subjectLabel.text = (billArray[indexPath.row].subjectOfBill)
        cell.paidByLabel.text = (billArray[indexPath.row].paidBy!)
        print(cell.subjectLabel)
        return cell
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
