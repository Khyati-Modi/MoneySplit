//
//  HomeViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 09/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var db: Firestore!

    var userName = [User]()
    let secondCategory = ["Khyati"]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    
    @IBOutlet weak var tableView2: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableView.delegate = self
        tableView.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        
        leftView.clipsToBounds = true
        rightView.clipsToBounds = true
        
        leftView.layer.cornerRadius = min(self.leftView.frame.width, self.leftView.frame.height) / 2.0
        rightView.layer.cornerRadius = min(self.leftView.frame.width, self.leftView.frame.height) / 2.0
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        tableView2.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")

    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if tableView.tag  == 1{
             count = userName.count
        }
       else if tableView.tag  == 2 {
            count = secondCategory.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell

        if tableView.tag  == 1{
            cell.userName.text = userName[indexPath.row].userName
            
        }
        else if tableView.tag  == 2 {
            cell.userName.text = secondCategory[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       var title = ""
        if tableView.tag  == 1{
           title = "People you owe"
            
        }
        else if tableView.tag  == 2 {
            title = "People who owe you"
        }
        return title
    }
    
    func getData(){
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.collection("UserInfo").document(Auth.auth().currentUser!.email!).collection("billInfo").getDocuments { (querySnapshot, err) in
            
            if let err = err {
                print("hello")
                print("Error getting documents: \(err)")
                return
            }
            else {
                for document in querySnapshot!.documents {
                    let newItem = User()
//                    ["Khyati & Saheb","Khyati & Dharmik","Dharmik & Saheb"]
                    if document.data()["paidFor"] as! String == "Khyati & Saheb" && Auth.auth().currentUser!.email! == "khyati.modi.sa@gmail.com" {
                        newItem.userName = ("Saheb")
                        self.userName.append(newItem)
                    }
                   
                }
                
                self.tableView.reloadData()
            }
        }
    }
}
