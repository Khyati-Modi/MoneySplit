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
    var amount : Int!
    var colour : String!
    var name = ""
    var username = ""
    var userEmail : String!
    var array : [String] = []
    var billArray = [BillHistory]()
    var billData = [MonthData]()
    var monthArray :  [String] = []
    let greenColor = UIColor(red:0.32, green:0.60, blue:0.33, alpha:1.0)
    let pinkColor = UIColor(red:0.98, green:0.30, blue:0.38, alpha:1.0)
    var SecCount = 0

    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var profileAmountLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!

    @IBAction func Backbutton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getUserEmailID()
        profileImage.image = userImage
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 1.5
        var amt : String = ""
        if UserDefaults.standard.string(forKey: "currency") == "INR"{
            amt = Conversion.shared.convertCurrency(dollarAmount: amount)
        }
        else {
            amt =  "\(amount!)$ "
        }
        if colour == "green" {
            profileImage.layer.borderColor = greenColor.cgColor
            userFullName.textColor = greenColor
            profileAmountLabel.textColor = greenColor
            profileAmountLabel.text = "Owe You \(amt)"
        }
        else {
            profileImage.layer.borderColor = pinkColor.cgColor
            userFullName.textColor = pinkColor
            profileAmountLabel.textColor = pinkColor
            profileAmountLabel.text = "You Owe \(amt)"
        }
        userFullName.font = UIFont(name: "Poppins", size: 28)
        profileAmountLabel.font = UIFont(name: "Poppins", size: 21)
        userFullName.text = selectedUserName
        profileImage.layer.cornerRadius = min(self.profileImage.frame.width, self.profileImage.frame.height) / 2.0
        historyTable.delegate = self
        historyTable.dataSource = self
        historyTable.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return monthArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerLabel = UILabel(frame: CGRect(x: 00, y: 28, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Poppins", size: 21)
        headerLabel.textColor = UIColor.black
        if section == 0 {
            headerLabel.text = monthArray[0]
        }
        if section == 1 {
            headerLabel.text = monthArray[1]
        }
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if billArray.count != 0{
            if section == 0 {
                SecCount = billArray.count
            }
        }
        if billData.count != 0{
            if section == 1 {
                SecCount =  billData .count
            }
        }
        return SecCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var amt = ""
        var totalAmt = ""
        let FriendTableViewCell = historyTable.dequeueReusableCell(withIdentifier: "FriendTableViewCell", for: indexPath) as! FriendTableViewCell
        
        if indexPath.section == 0 {
            if billArray.count != 0{
                if UserDefaults.standard.string(forKey: "currency") == "INR"{
                    amt = Conversion.shared.convertCurrency(dollarAmount: billArray[indexPath.row].money!)
                    totalAmt = Conversion.shared.convertCurrency(dollarAmount: Int(billArray[indexPath.row].totalAmount!))
                }
                else {
                    amt =  "\(billArray[indexPath.row].money!)$ "
                   totalAmt = "\(billArray[indexPath.row].totalAmount!)$"
                }
                
                if  billArray[indexPath.row].paidBy != "You" {
                FriendTableViewCell.subjectLabel.textColor = pinkColor
                FriendTableViewCell.paidByLabel.textColor = pinkColor
                FriendTableViewCell.amountLabel.textColor = pinkColor
                }
                if billArray[indexPath.row].paidBy == "You" {
                    FriendTableViewCell.subjectLabel.textColor = greenColor
                    FriendTableViewCell.paidByLabel.textColor = greenColor
                    FriendTableViewCell.amountLabel.textColor = greenColor
                }
                FriendTableViewCell.subjectLabel.text = (billArray[indexPath.row].subjectOfBill)
                FriendTableViewCell.paidByLabel.text = ("\(billArray[indexPath.row].paidBy!) paid  \(totalAmt)")
                FriendTableViewCell.amountLabel.text = ("\(amt)")
                return FriendTableViewCell
            }
        }
        
        if indexPath.section == 1 {
            if billData.count != 0{
                if UserDefaults.standard.string(forKey: "currency") == "INR"{
                    amt = Conversion.shared.convertCurrency(dollarAmount: billData[indexPath.row].money!)
                    totalAmt = Conversion.shared.convertCurrency(dollarAmount: Int(billData[indexPath.row].totalAmount!))
                }
                else {
                    amt =  "\(billData[indexPath.row].money!)$ "
                    totalAmt = "\(billData[indexPath.row].totalAmount!)$"
                }
                if  billData[indexPath.row].paidBy != "You" {
                    FriendTableViewCell.subjectLabel.textColor = pinkColor
                    FriendTableViewCell.paidByLabel.textColor = pinkColor
                    FriendTableViewCell.amountLabel.textColor = pinkColor
                }
                if billData[indexPath.row].paidBy == "You" {
                    FriendTableViewCell.subjectLabel.textColor = greenColor
                    FriendTableViewCell.paidByLabel.textColor = greenColor
                    FriendTableViewCell.amountLabel.textColor = greenColor
                }
                FriendTableViewCell.subjectLabel.text = (billData[indexPath.row].subjectOfBill)
                FriendTableViewCell.paidByLabel.text = ("\(billData[indexPath.row].paidBy!) paid  \(totalAmt)")
                FriendTableViewCell.amountLabel.text = ("\(amt)")
                return FriendTableViewCell
            }
        }
        return FriendTableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "BillDataViewController") as! BillDataViewController
        if indexPath.section == 0 {
            vc.selectedItem = (billArray[indexPath.row].subjectOfBill)
            if (billArray[indexPath.row].paidBy!) == "You" {
                vc.addedByUserName = ((Auth.auth().currentUser?.email)!)
                vc.sender = "owner"
                vc.paidByUser = "You"
                self.navigationController?.pushViewController(vc, animated: true)
                historyTable.deselectRow(at: indexPath, animated: true)
            }
            else{
                name = (billArray[indexPath.row].paidBy!)
                vc.paidByUser = (billArray[indexPath.row].paidBy!)
                vc.sender = "user"
                
                self.db.collection("UserSignUp").getDocuments{ (QuerySnapshot, err) in
                    for document in QuerySnapshot!.documents {
                        if self.name == (document.data()["fullName"] as? String) {
                            self.username  = document.documentID
                            vc.addedByUserName = self.username
                            self.navigationController?.pushViewController(vc, animated: true)
                            self.historyTable.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
            }
        }
        
        if indexPath.section == 1 {
            vc.selectedItem = (billData[indexPath.row].subjectOfBill)
            if (billData[indexPath.row].paidBy!) == "You" {
                vc.addedByUserName = ((Auth.auth().currentUser?.email)!)
                vc.sender = "owner"
                vc.paidByUser = "You"
                self.navigationController?.pushViewController(vc, animated: true)
                historyTable.deselectRow(at: indexPath, animated: true)
            }
            else{
                name = (billData[indexPath.row].paidBy!)
                vc.paidByUser = (billData[indexPath.row].paidBy!)
                vc.sender = "user"
                
                self.db.collection("UserSignUp").getDocuments{ (QuerySnapshot, err) in
                    for document in QuerySnapshot!.documents {
                        if self.name == (document.data()["fullName"] as? String) {
                            self.username  = document.documentID
                            vc.addedByUserName = self.username
                            self.navigationController?.pushViewController(vc, animated: true)
                            self.historyTable.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func getUserEmailID(){
        let user = (Auth.auth().currentUser!.email!)
        self.db.collection("UserSignUp").getDocuments{ (QuerySnapshot, err) in
            for document in QuerySnapshot!.documents {
                if self.selectedUserName == (document.data()["fullName"] as? String) {
                    self.array.append(user)
                   let paidByEmail = document.documentID
                    self.array.append(paidByEmail)
                    self.getdata()
                }
            }
        }
    }
        
    func getdata() {
        DispatchQueue.main.async {
            self.billArray.removeAll()

            self.db.collection("PeopleWhoOweYou").getDocuments{ (QuerySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }
                else {
                    let emailId = self.array[0]
                    let name = self.array[1]
                    
                    for document in QuerySnapshot!.documents {
                        
                        if emailId == document.data()["paidBy"] as! String && name == document.data()["name"] as! String {
                            var monthVal = 0
                            let newMonth = (document.data()["Month"] as! String)
                            for month in self.monthArray {
                                if month == newMonth {
                                    monthVal = 1
                                    continue
                                }
                            }
                            if monthVal == 0 {
                                self.monthArray.append(newMonth)
                            }
                            if self.monthArray[0] == (document.data()["Month"] as! String) {
                                let billInfo = BillHistory()

                                billInfo.subjectOfBill = document.data()["Subject"] as? String
                                if (document.data()["paidBy"] as! String) == Auth.auth().currentUser?.email{
                                    billInfo.paidBy = "You"
                                }
                                else {
                                    billInfo.paidBy = self.selectedUserName
                                }
                                let countTwo = (document.data()["totalAmount"] as! Int)
                                billInfo.totalAmount = countTwo
                                billInfo.money = (document.data()["money"] as! Int)
                                billInfo.billMonth = (document.data()["Month"] as! String)
                                self.billArray.append(billInfo)
                                self.historyTable.reloadData()
                            }
                            if self.monthArray[0] != (document.data()["Month"] as! String) {
                                let billDetail = MonthData()
                                
                                billDetail.subjectOfBill = document.data()["Subject"] as? String
                                if (document.data()["paidBy"] as! String) == Auth.auth().currentUser?.email{
                                    billDetail.paidBy = "You"
                                }
                                else {
                                    billDetail.paidBy = self.selectedUserName
                                }
                                let countTwo = (document.data()["totalAmount"] as! Int)
                                billDetail.totalAmount = countTwo
                                billDetail.money = (document.data()["money"] as! Int)
                                billDetail.billMonth = (document.data()["Month"] as! String)
                                self.billData.append(billDetail)
                                self.historyTable.reloadData()
                            }
                        }
                        else if emailId == document.data()["name"] as! String && name == document.data()["paidBy"] as! String {
                            var monthVal = 0
                            let newMonth = (document.data()["Month"] as! String)
                            for month in self.monthArray {
                                if month == newMonth {
                                    monthVal = 1
                                    continue
                                }
                            }
                            if monthVal == 0 {
                                self.monthArray.append(newMonth)
                            }
                                if self.monthArray[0] == (document.data()["Month"] as! String) {
                                    let billInfo = BillHistory()
                                    
                                    billInfo.subjectOfBill = document.data()["Subject"] as? String
                                    if (document.data()["paidBy"] as! String) == Auth.auth().currentUser?.email{
                                        billInfo.paidBy = "You"
                                    }
                                    else{
                                        billInfo.paidBy = self.selectedUserName
                                    }
                                    let countTwo = (document.data()["totalAmount"] as! Int)
                                    billInfo.totalAmount = countTwo
                                    billInfo.money = Int(document.data()["money"] as! Int)
                                    billInfo.billMonth = (document.data()["Month"] as! String)
                                    self.billArray.append(billInfo)
                                }
                                if self.monthArray[0] != (document.data()["Month"] as! String) {
                                    let billDetail = MonthData()
                                    
                                    billDetail.subjectOfBill = document.data()["Subject"] as? String
                                    if (document.data()["paidBy"] as! String) == Auth.auth().currentUser?.email{
                                        billDetail.paidBy = "You"
                                    }
                                    else {
                                        billDetail.paidBy = self.selectedUserName
                                    }
                                    let countTwo = (document.data()["totalAmount"] as! Int)
                                    billDetail.totalAmount = countTwo
                                    billDetail.money = (document.data()["money"] as! Int)
                                    billDetail.billMonth = (document.data()["Month"] as! String)
                                    self.billData.append(billDetail)
                                    self.historyTable.reloadData()
                                }
                        }
                        self.historyTable.reloadData()
                    }
                }
            }
        }
    }
}
