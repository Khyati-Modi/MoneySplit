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
    var SecCount = 0

    var currentUser : String!
    var currentUser2 : String!
    var totalOweAmount = 0.0
    
    let greenColour = UIColor(red:0.32, green:0.60, blue:0.33, alpha:1.0)
    let pinkColour = UIColor(red:0.98, green:0.30, blue:0.38, alpha:1.0)

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
       
        peopleYouOwe()
        peopleWhoOweYou()
//        tableView.reloadData()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        
        leftLabel.clipsToBounds = true
        rightLabel.clipsToBounds = true
        
        leftLabel.backgroundColor = pinkColour
        rightLabel.backgroundColor =  greenColour
        
        leftLabel.layer.cornerRadius = min(self.leftLabel.frame.width, self.leftLabel.frame.height) / 2.0
        rightLabel.layer.cornerRadius = min(self.leftLabel.frame.width, self.leftLabel.frame.height) / 2.0
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if peopleArray.count != 0{
            if section == 0 {
                SecCount = peopleArray.count
            }
        }
       if section == 1 {
            SecCount =  userArray.count
        }
        return SecCount
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        print(peopleArray.count)
       
        if peopleArray.count != 0{
            if indexPath.section == 0 {
              
                var  amount = 0.0
                var totalAmount = 0.0
                
                cell.userName.text =  peopleArray[indexPath.row].peopleFullName
                cell.profileImage.image = peopleArray[indexPath.row].peopleProfileImage
                cell.amountButtonOutlet.setTitle("\(peopleArray[indexPath.row].peopleCount!)$", for: .normal)
                cell.amountButtonOutlet.tintColor = pinkColour
                
                for i in 0..<peopleArray.count {
                    amount = peopleArray[i].peopleCount!
                }
                totalAmount = totalAmount + amount
                leftLabel.text = "YOU OWE      \(totalAmount)$"
                
                return cell
            }
        }
        
        if indexPath.section == 1{
            if userArray.count != 0 {
                
                var  amount = 0.0
                var totalAmount = 0.0

                cell.userName.text = userArray[indexPath.row].userFullname
                cell.profileImage.image = userArray[indexPath.row].userImage
                cell.amountButtonOutlet.setTitle("\(userArray[indexPath.row].userCount!)$", for: .normal)
                cell.amountButtonOutlet.tintColor = greenColour
                
                for i in 0..<userArray.count {
                    amount = userArray[i].userCount!
                    totalAmount = totalAmount + amount
                 }
                rightLabel.text = "OWE YOU \(totalAmount)$"
                return cell
            }
             return UITableViewCell()
        }
            
        else{
            return UITableViewCell()
            }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel = UILabel(frame: CGRect(x: 00, y: 28, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Poppins", size: 24)
        headerLabel.textColor = UIColor.black
        
        if section == 0{
            headerLabel.text = "People you owe"
        }
        if section == 1{
            
        headerLabel.text = "People who owe you"
        }
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: 28  , width: headerLabel.bounds.size.width, height: 1)
        bottomLine2.backgroundColor = UIColor.black.cgColor
        headerLabel.layer.addSublayer(bottomLine2)
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendsPageViewController") as! FriendsPageViewController
        
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
                self.getData()
            }
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
                        print(userInfo)
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
        
        self.peopleArray.removeAll()

        self.db.collection("PeopleWhoOweYou").getDocuments(completion: { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else{
                var countTwo : String!
//             let peopleInfo = PeopleData()
                for document in QuerySnapshot!.documents {
                    let paidByUser = document.data()["paidBy"]  as! String
                    let nameOfUser = document.data()["name"] as! String
                    
                    if Auth.auth().currentUser?.email != paidByUser {
                        if Auth.auth().currentUser?.email == nameOfUser {
                            self.peopleArray.removeAll()

                            countTwo = (document.data()["money"] as! String)
                            self.totalValue = self.totalValue + (countTwo as NSString).doubleValue
                            self.currentUser = paidByUser
                            self.getDatatOfPeople()
                        }
                    }
                }
               
                self.tableView.reloadData()
            }
        })
    }
    func getDatatOfPeople(){
        self.db.collection("UserSignUp").getDocuments { (query, error) in
            
            for document in (query?.documents)!{

                if document.documentID == self.currentUser{
                    let peopleInfo = PeopleData()
                    
                    peopleInfo.peopleFullName = (document.data()["fullName"] as! String)
                    peopleInfo.peopleUserName = (document.data()["userName"] as! String)
                    peopleInfo.peopleCount = self.totalValue
                    
                    let imageName = peopleInfo.peopleUserName!
                    
                    let storageRef = Storage.storage().reference(withPath: "uploads/\(imageName).jpg")
                    storageRef.getData(maxSize: 4 * 1024 * 1024) {(data, error) in
                        if let error = error {
                            print("\(error)")
                            return
                        }
                        if let data = data {
                            peopleInfo.peopleProfileImage = UIImage(data: data)!
                        }
                    }
                    print(peopleInfo.peopleCount)
                    self.peopleArray.append(peopleInfo)
                    self.tableView.reloadData()
                }
            }
        }
    }
}
