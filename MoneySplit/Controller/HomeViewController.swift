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
    var emailOfUser  : [String] = []
    var currentUserArray  : [String] = []
    var countArray  : [Int] = []

    var monthArray : [String]!
    var user : Set<String> = []
    var  people : Set<String>  = []
    
    var count = 0
    var sum = 0.0
    var totalValue = 0
    var SecCount = 0
    var currentUser : String!
    var totalOweAmount = 0.0
    var array : [String] = []
    var prize : [Int] = []
    let greenColour = UIColor(red:0.32, green:0.60, blue:0.33, alpha:1.0)
    let pinkColour = UIColor(red:0.98, green:0.30, blue:0.38, alpha:1.0)

    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "currency") == "INR"{
            let amt = Conversion.shared.convertCurrency(dollarAmount: 0)
            leftLabel.text = "\(amt)"
            rightLabel.text = "\(amt)"
        }
        else{
            leftLabel.text = "0$"
            rightLabel.text = "0$"
        }

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
       
        peopleYouOwe()
        peopleWhoOweYou()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        
        leftView.clipsToBounds = true
        rightView.clipsToBounds = true
        
        leftView.backgroundColor = pinkColour
        rightView.backgroundColor =  greenColour
        
        leftView.layer.cornerRadius = min(self.leftView.frame.width, self.leftView.frame.height) / 2.0
        rightView.layer.cornerRadius = min(self.rightView.frame.width, self.rightView.frame.height) / 2.0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel = UILabel(frame: CGRect(x: 00, y: 28, width: tableView.bounds.size.width, height: 60))
        headerLabel.font = UIFont(name: "Poppins", size: 24)
        headerLabel.textColor = UIColor.black
        
        if section == 0{
            headerLabel.text = "People you owe"
        }
        if section == 1{
            
            headerLabel.text = "People who owe you"
        }
        let bottomLine2 = CALayer()
        bottomLine2.frame = CGRect(x: 0, y: 32  , width: headerLabel.bounds.size.width, height: 1)
        bottomLine2.backgroundColor = UIColor.black.cgColor
        headerLabel.layer.addSublayer(bottomLine2)
        return headerLabel
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
        
       
        
        if peopleArray.count == 0 {
            if indexPath.section == 0{
                cell.userName.text = "Hurray! Nothing to Pay"
            }
        }
        if peopleArray.count != 0{
            if indexPath.section == 0 {
              
                var  amount = 0
                var totalAmount = 0
                
                var amt = ""
                var totalamt = ""
                
                if UserDefaults.standard.string(forKey: "currency") == "INR"{
                    amt = Conversion.shared.convertCurrency(dollarAmount: peopleArray[indexPath.row].peopleCount)
                    
                    for i in 0..<peopleArray.count {
                        amount = peopleArray[i].peopleCount!
                        totalAmount = totalAmount + amount
                    }
                    totalamt = Conversion.shared.convertCurrency(dollarAmount: totalAmount)
                    leftLabel.text = " \(totalamt)"
                    
                }
                else {
                    amt =  "\(peopleArray[indexPath.row].peopleCount!)$ "
                    
                    for i in 0..<peopleArray.count {
                        amount = peopleArray[i].peopleCount!
                        totalAmount = totalAmount + amount
                    }
                    leftLabel.text = " \(totalAmount)$"
                }
                cell.userName.text =  peopleArray[indexPath.row].peopleFullName
                cell.profileImage.image = peopleArray[indexPath.row].peopleProfileImage
                
                cell.amountButtonOutlet.setTitle("\(amt)", for: .normal)
                cell.amountButtonOutlet.tintColor = pinkColour
                return cell
            }
        }
         if userArray.count != 0 {
            if indexPath.section == 1{
           
                var  amount = 0
                var totalAmount = 0
                
                var amt = ""
                var totalamt = ""
                
                if UserDefaults.standard.string(forKey: "currency") == "INR"{
                    amt = Conversion.shared.convertCurrency(dollarAmount: userArray[indexPath.row].userCount )
                    
                    for i in 0..<userArray.count {
                        amount = userArray[i].userCount!
                        totalAmount = totalAmount + amount
                    }
                    totalamt = Conversion.shared.convertCurrency(dollarAmount: totalAmount)
                    rightLabel.text = " \(totalamt)"
                    
                }
                else {
                    amt =  "\(userArray[indexPath.row].userCount!)$ "
                    
                    for i in 0..<userArray.count {
                        amount = userArray[i].userCount!
                        totalAmount = totalAmount + amount
                    }
                    rightLabel.text = " \(totalAmount)$"
                }
                
                cell.userName.text = userArray[indexPath.row].userFullname
                cell.profileImage.image = userArray[indexPath.row].userImage
                cell.amountButtonOutlet.setTitle("\(amt)", for: .normal)
                cell.amountButtonOutlet.tintColor = greenColour
                
                return cell
            }
             return UITableViewCell()
        }
        else{
            return UITableViewCell()
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "FriendsPageViewController") as! FriendsPageViewController

        if indexPath.section == 0 {
            vc.selectedUserName = peopleArray[indexPath.row].peopleFullName
            vc.userImage = peopleArray[indexPath.row].peopleProfileImage
            vc.amount = peopleArray[indexPath.row].peopleCount
            vc.userEmail = peopleArray[indexPath.row].peopleEmailId
            vc.colour = "pink"
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)

        }
        if indexPath.section == 1 {
            vc.selectedUserName = userArray[indexPath.row].userFullname
            vc.userImage = userArray[indexPath.row].userImage
            vc.amount = userArray[indexPath.row].userCount
            vc.userEmail = userArray[indexPath.row].userEmailId
            vc.colour = "green"
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    //MARK: peopleWhoOweYou Function
    func peopleWhoOweYou(){
        self.userArray.removeAll()
        
        db.collection("UserSignUp").getDocuments { (query, error) in
            if error != nil{
                print("Error to find UserSignUp Database")
            }
            else{
                for document in query!.documents {
                    if Auth.auth().currentUser?.email == document.documentID {
                        continue
                    }
                    else{
                        let newID = document.documentID
                        self.emailOfUser.append(newID)
                    }
                }
            self.db.collection("PeopleWhoOweYou").getDocuments(completion: { (QuerySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    else{
                        var value = 0
                      
                        
                        for document in QuerySnapshot!.documents {

                            let paidByUser = document.data()["paidBy"]  as! String

                            
                            for i in 0..<self.emailOfUser.count {
                                let userEmail = self.emailOfUser[i]

                                
                                if Auth.auth().currentUser?.email == paidByUser {
                                      self.count = 0

                                    if userEmail == document.data()["name"] as! String {
                                        let countTwo = document.data()["money"] as! Int
                                        self.count = self.count + countTwo
                                        self.currentUser = (document.data()["name"] as! String)
                                        self.currentUserArray.append(self.currentUser)
                                        self.countArray.append(self.count)
                                        self.user.insert(self.currentUser)
                                        print(self.user.count)
                                        value = 1
                                    }
                                }
                            }
                        }
                        if value == 1 {
                            self.getData()
                        }
                    }
                })
            }
        }
    }
        func getData(){
            self.db.collection("UserSignUp").getDocuments { (query, error) in
                for document in (query?.documents)!{
                    for i in 0..<self.user.count {
                        print(self.user.count)
                        if document.documentID == self.currentUserArray[i] {
                            print("Here users = \(self.user)")
                            let userInfo = User()
                            
                            userInfo.userFullname = (document.data()["fullName"] as! String)
                            userInfo.userName = (document.data()["userName"] as! String)
                            userInfo.userEmailId = (document.data()["email"] as! String)
                            userInfo.userCount = self.countArray[i]

                            let imageName =  userInfo.userName!
                            let storageRef = Storage.storage().reference(withPath: "uploads/\(imageName).jpg")
                            storageRef.getData(maxSize: 4 * 1024 * 1024) {(data, error) in
                                if let error = error {
                                    print("\(error)")
                                    return
                                }
                                if let data = data {
                                    userInfo.userImage = UIImage(data: data)!
                                    self.tableView.reloadData()
                                }
                            }
                            self.userArray.append(userInfo)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    
    //MARK: peopleYouOwe
    func peopleYouOwe(){

        self.peopleArray.removeAll()
        
        self.db.collection("PeopleWhoOweYou").getDocuments(completion: { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else{
                var increase = 0
                var countTwo : Int!
                self.totalValue = 0

                for document in QuerySnapshot!.documents {
                    let paidByUser = document.data()["paidBy"]  as! String
                    let nameOfUser = document.data()["name"] as! String
                    
                    if Auth.auth().currentUser?.email != paidByUser {

                        if Auth.auth().currentUser?.email == nameOfUser {
                            self.peopleArray.removeAll()

                            countTwo = (document.data()["money"] as! Int)
                            self.totalValue = self.totalValue + countTwo
                            self.currentUser = paidByUser
                            self.array.append(self.currentUser!)
                            self.people.insert(self.currentUser)
                            self.prize.append(self.totalValue)
                            increase = 1
                        }
                    }
                }
                if increase == 1{
                    self.setUser()
                }
            }
        })
    }
    func setUser(){
        self.db.collection("UserSignUp").getDocuments { (query, error) in

            for document in (query!.documents){
                for i in 0..<self.people.count{
                    if document.documentID == self.array[i] {
                        
                        let peopleInfo = PeopleData()
                        
                        peopleInfo.peopleFullName = (document.data()["fullName"] as! String)
                        peopleInfo.peopleUserName = (document.data()["userName"] as! String)
                        peopleInfo.peopleEmailId = (document.data()["email"] as! String)
                        peopleInfo.peopleCount = self.prize[i]
                        self.tableView.reloadData()
                        
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
                        self.peopleArray.append(peopleInfo)
                        self.tableView.reloadData()
                    }
                }
        
            }
        }
    }
}
