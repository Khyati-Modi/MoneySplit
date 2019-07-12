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

    var userArray = [User]()
    var peopleArray = [PeopleData]()
    var count = 0.0
    var sum = 0.0
    var totalValue = 0.0
    
    
    var currentUser : String!
    var currentUser2 : String!
    var totalOweAmount = 0.0

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        peopleWhoOweYou()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")

        leftLabel.clipsToBounds = true
        rightView.clipsToBounds = true
        
        leftLabel.layer.cornerRadius = min(self.leftLabel.frame.width, self.leftLabel.frame.height) / 2.0
        rightView.layer.cornerRadius = min(self.leftLabel.frame.width, self.leftLabel.frame.height) / 2.0
      
        peopleYouOwe()
        myTable.delegate = self
        myTable.dataSource = self
        myTable.register(UINib(nibName: "SecondTableViewCell", bundle: nil), forCellReuseIdentifier: "SecondTableViewCell")
        
       
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if tableView.tag  == 1{
             count = userArray.count
           
        }
       else if myTable.tag  == 2 {
            count = peopleArray.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        for i in indexPath{
            let amount  = userArray[i].userCount!
            totalOweAmount = totalOweAmount + amount
        }
        if tableView.tag  == 1 {
            cell.userName.text = userArray[indexPath.row].userFullname
            cell.profileImage.image = userArray[indexPath.row].userImage
            cell.amountButtonOutlet.setTitle("\(userArray[indexPath.row].userCount!)$", for: .normal)
            cell.amountButtonOutlet.tintColor = UIColor.green
           
            leftLabel.text = "Owe You:\(totalOweAmount)$"
            return cell
        }
        
       else if myTable.tag  == 2 {
            let cell = myTable.dequeueReusableCell(withIdentifier: "SecondTableViewCell", for: indexPath) as! SecondTableViewCell

            cell.peopleNameLabel.text  = peopleArray[indexPath.row].peopleUserName
            cell.profileImage.image = peopleArray[indexPath.row].peopleProfileImage
            cell.prizeLabel.setTitle("\(String(describing: peopleArray[indexPath.row].peopleCount))", for: .normal)
            return cell
        }
        return UITableViewCell()

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       var title = ""
        if tableView.tag  == 1{
            title = "People who owe you"

            
        }
        else if myTable.tag  == 2 {
            title = "People you owe"

        }
        return title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendsPageViewController") as! FriendsPageViewController
        
        vc.selectedUserName = userArray[indexPath.row].userFullname
        vc.userImage = userArray[indexPath.row].userImage
        vc.amount = userArray[indexPath.row].userCount
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func peopleWhoOweYou(){
        
        self.userArray.removeAll()
        db.collection("PeopleWhoOweYou").getDocuments(completion: { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else{
                for document in QuerySnapshot!.documents {
                    print("hello")
                    let paidByUser = document.data()["paidBy"]  as! String
                    var userEmail = ""
                    if paidByUser == "khyati.modi.sa@gmail.com"{
                         userEmail = "dharmik.dalwadi.sa@gmail.com"
                    }
                    else if paidByUser == "dharmik.dalwadi.sa@gmail.com" || paidByUser == "sahebsingh.tuleja.sa@gmail.com" {
                         userEmail = "khyati.modi.sa@gmail.com"
                    }
                    print(userEmail)
                    
                    if Auth.auth().currentUser?.email == paidByUser {
                        
                        if userEmail == document.data()["name"] as! String {
                            let countTwo = document.data()["money"] as! String
                            self.count = (self.count + (countTwo as NSString).doubleValue)
                            self.currentUser = (document.data()["name"] as! String)
                            self.tableView.reloadData()
                        }
                        else{
                            let sumTwo = (document.data()["money"] as! String)
                            self.sum = (self.sum + (sumTwo as NSString).doubleValue)
                            self.currentUser2 = (document.data()["name"] as! String)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            self.getData()
        })
    }
        func getData(){
            self.db.collection("UserSignUp").getDocuments { (query, error) in
                
                for document in (query?.documents)!{

                    if document.documentID == self.currentUser{
                        let userInfo = User()

                        userInfo.userFullname = (document.data()["fullName"] as! String)
                        userInfo.userName = (document.data()["userName"] as! String)
                        userInfo.userCount = self.count
                        let imageName =  userInfo.userName!
                        let storageRef = Storage.storage().reference(withPath: "uploads/\(imageName).jpg")
                        storageRef.getData(maxSize: 4 * 1024 * 1024) {(data, error) in
                            if let error = error {
                                print("\(error)")
                                return
                            }
                            if let data = data {
                                userInfo.userImage = UIImage(data: data)!
                                print("File Downloaded")
                                self.tableView.reloadData()
                            }
                        }
                        self.userArray.append(userInfo)
                        self.tableView.reloadData()
                    }
                  else  if document.documentID == self.currentUser2 {
                        let userInfo = User()

                        userInfo.userFullname = (document.data()["fullName"] as! String)
                        userInfo.userName = (document.data()["userName"] as! String)
                        userInfo.userCount = self.sum
                        
                        let imageFileName = document.data()["userName"] as! String
                        
                        let storageRef = Storage.storage().reference(withPath: "uploads/\(imageFileName).jpg")
                        storageRef.getData(maxSize: 4 * 1024 * 1024){(data, error) in
                        
                            if let error = error {
                                print("\(error)")
                                return
                            }
                            if let data = data {
                                userInfo.userImage = UIImage(data: data)!
                                print("File Downloaded")
                                self.tableView.reloadData()
                            }
                        }
                        self.userArray.append(userInfo)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    
    func peopleYouOwe(){
        self.db.collection("PeopleWhoOweYou").getDocuments(completion: { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else{
             let peopleInfo = PeopleData()
                for document in QuerySnapshot!.documents {
                    let paidByUser = document.data()["paidBy"]  as! String
                    let nameOfUSer = document.data()["name"] as! String
                    if Auth.auth().currentUser?.email != paidByUser {
                        if Auth.auth().currentUser?.email == nameOfUSer {
                            let countTwo = document.data()["money"] as! String
                            self.currentUser = paidByUser
                            self.totalValue = self.totalValue + (countTwo as NSString).doubleValue
                        }
                    }
                }
                print(peopleInfo.peopleCount)
                self.peopleArray.append(peopleInfo)
                
                self.tableView.reloadData()
            }
            self.getDatatOfPeople()
        })
    }
    func getDatatOfPeople(){
            self.db.collection("UserSignUp").getDocuments { (query, error) in
                
                for document in (query?.documents)!{
                    
                    if document.documentID == self.currentUser{
                        let peopleInfo = PeopleData()
                        
                        peopleInfo.peopleFullName = (document.data()["fullName"] as! String)
                        peopleInfo.peopleUserName = (document.data()["userName"] as! String)
                        peopleInfo.peopleCount = self.count
                        
                        let imageName = peopleInfo.peopleUserName!
                        
                        let storageRef = Storage.storage().reference(withPath: "uploads/\(imageName).jpg")
                        storageRef.getData(maxSize: 4 * 1024 * 1024) {(data, error) in
                            if let error = error {
                                print("\(error)")
                                return
                            }
                            if let data = data {
                                peopleInfo.peopleProfileImage = UIImage(data: data)!
                                print("File Downloaded")
                                self.tableView.reloadData()
                            }
                        }
                        self.peopleArray.append(peopleInfo)
                        self.tableView.reloadData()
                    }
                }
            }
        }
}
