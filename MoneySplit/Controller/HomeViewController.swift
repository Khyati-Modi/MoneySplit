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
    var count = 0.0
    var sum = 0.0
    var countArray = ["",""]


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
            cell.userName.text = userName[indexPath.row].userFullname
            cell.profileImage.image = userName[indexPath.row].userImage
            cell.amountButtonOutlet.setTitle("\(countArray[indexPath.row])", for: .normal)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendsPageViewController") as! FriendsPageViewController
        
        vc.selectedUserName = userName[indexPath.row].userFullname
        vc.userImage = userName[indexPath.row].userImage
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getData(){
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        db.collection("UserSignUp").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in QuerySnapshot!.documents {
                    if Auth.auth().currentUser?.email! == document.documentID {
                        continue
                    }
                    else {
                        self.db.collection("UserSignUp").getDocuments(completion: { (email, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            }
                            else{
                                let userArray = User()
                                userArray.userFullname = (document.data()["fullName"] as! String)
                                userArray.userName = (document.data()["userName"] as! String)
                                let userEmailId = (document.data()["email"] as! String)
                                
                                self.db.collection("PeopleWhoOweYou").getDocuments(completion: { (QuerySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    }
                                    else{
                                        for document in QuerySnapshot!.documents {
                                            let paidByUser = document.data()["paidBy"]  as! String
                                            print(paidByUser)
//                                            if Auth.auth().currentUser?.email == paidByUser {
                                            if userEmailId == document.data()["name"] as! String{
//                                                if userEmailId == document.data()["name"] as! String{
                                                    let countTwo = document.data()["money"] as! String
                                                    print(countTwo)
                                                    self.count = self.count + (countTwo as NSString).doubleValue
                                                    print(self.count)
                                                    self.tableView.reloadData()
                                                }
                                            else{
                                                let sumTwo = document.data()["money"] as! String
                                                print(sumTwo)
                                                self.sum = self.sum + (sumTwo as NSString).doubleValue
                                                print(self.sum)
                                                self.tableView.reloadData()
                                            }
                                        }
                                    }
                                    self.countArray = ["\(self.count)","\(self.sum)"]
                                    self.tableView.reloadData()

                                })
                                self.db.collection("UserInfo").document("\(String(describing: userArray.userName))").collection("billInfo").getDocuments(completion: { (querySnapshot, err) in
                                    let imageFileName = document.data()["userName"] as! String
                                    let storageRef = Storage.storage().reference(withPath: "uploads/\(String(describing: imageFileName)).jpg")
                                    storageRef.getData(maxSize: 4 * 1024 * 1024) {(data, error) in
                                        if let error = error {
                                            print("\(error)")
                                            return
                                        }
                                        if let data = data {
                                            userArray.userImage = UIImage(data: data)!
                                            print("File Downloaded")
                                            self.tableView.reloadData()
                                        }
                                    }
                                    self.userName.append(userArray)
                                    self.tableView.reloadData()
                                })
                            }
                        })
                    }
                }
            }
        }
    }
}
