//
//  AddBillViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 09/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class AddBillViewController: UIViewController {
    var activityIndicator  = UIActivityIndicatorView()
    var paidByEmail : String!
    var groupInfoArray = [GroupData]()
    var paidByArray = ["kmodi","saheb","Dharmik","kishan"]
    
    let storage = Storage.storage()
    var db: Firestore!
    
    var userPickerView : UIPickerView!
    var selectedGroup : Int!
    var selectedUser : Int!
    
    var groupArray : [String] = []
    
    var numberOfUser = 0
    var selectedGroupRow : Int = 0
    var selectedUserRow : Int = 0
    var userPickerArray : [String : String] = [:]
    
    var totalAmount : Int!
    var rupeeArray : [Int] = []
    var dolarArray : [Int] = []
    var currencyImage : UIImage!
    var tag : Int!
    let grayColour = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    
    
    @IBOutlet weak var SplitView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subjectOfBill: UITextField!
    @IBOutlet weak var totalAmountOfBill: UITextField!
    @IBOutlet weak var forLabel: UILabel!
    @IBOutlet weak var splitManually: UILabel!
    
    @IBOutlet weak var PaidByLabel: UILabel!
    override func viewDidLoad() {
        tag = 0
        
        super.viewDidLoad()
        subjectOfBill.text = ""
        totalAmountOfBill.text = ""
        PaidByLabel.text = ""
        forLabel.text = ""
        
        let currencyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        
        if UserDefaults.standard.string(forKey: "currency") == "USD" {
            currencyImage = UIImage(named: "Currency")
        }
        else if UserDefaults.standard.string(forKey: "currency") == "INR" {
            currencyImage = UIImage(named: "rupee")
        }
        currencyImageView.contentMode = .scaleAspectFill
        currencyImageView.image = currencyImage
        totalAmountOfBill.leftView = currencyImageView
        totalAmountOfBill.leftViewMode = UITextField.ViewMode.always
        
        getBackground()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        fetchGroupArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.string(forKey: "currency") == "USD" {
            currencyImage = UIImage(named: "Currency")
        }
        else if UserDefaults.standard.string(forKey: "currency") == "INR" {
            currencyImage = UIImage(named: "rupee")
        }
    }
    
    func getBackground(){
        
        subjectOfBill.autocorrectionType = .no
        subjectOfBill.borderStyle = .none
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: subjectOfBill.frame.height - 1, width: self.subjectOfBill.frame.width + 1 , height: 4)
        bottomLine.backgroundColor = grayColour.cgColor
        subjectOfBill.borderStyle = UITextField.BorderStyle.none
        subjectOfBill.layer.addSublayer(bottomLine)
        
        totalAmountOfBill.autocorrectionType = .no
        totalAmountOfBill.borderStyle = .none
        let bLine = CALayer()
        bLine.frame = CGRect(x: 0, y: totalAmountOfBill.frame.height - 1, width: self.totalAmountOfBill.frame.width + 1 , height: 4)
        bLine.backgroundColor = grayColour.cgColor
        totalAmountOfBill.borderStyle = UITextField.BorderStyle.none
        totalAmountOfBill.layer.addSublayer(bLine)
        
        let baseLine = CALayer()
        baseLine.frame = CGRect(x: 0, y: PaidByLabel.frame.height - 1, width: self.PaidByLabel.frame.width + 1 , height: 4)
        baseLine.backgroundColor = grayColour.cgColor
        PaidByLabel.layer.addSublayer(baseLine)
        
        
        let bottom = CALayer()
        bottom.frame = CGRect(x: 0, y: forLabel.frame.height - 1, width: self.forLabel.frame.width + 1 , height: 4)
        bottom.backgroundColor = grayColour.cgColor
        forLabel.layer.addSublayer(bottom)
        
        SplitView.clipsToBounds = true
        SplitView.layer.cornerRadius = 35
        SplitView.layer.borderWidth = 3
        SplitView.layer.borderColor = UIColor(red:0.64, green:0.63, blue:0.63, alpha:1.0).cgColor
        SplitView.layer.backgroundColor = UIColor.white.cgColor
        
    }
    
    
    @IBAction func paidByDropDown(_ sender: UIButton) {
        tag = 1
        self.userPickerView = UIPickerView(frame:CGRect(x: 120, y: 186, width: 250 , height: 150))
        self.userPickerView.delegate = self
        self.userPickerView.dataSource = self
        self.userPickerView.backgroundColor = UIColor.white
        self.userPickerView.selectRow(selectedGroupRow, inComponent: 0, animated: true)
        self.view.addSubview(userPickerView)
    }
    
    
    func fetchGroupArray(){
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.collection("SelectYourGroup").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else  {
                
                var newGroup : String!
                for document in (QuerySnapshot?.documents)!{
                    newGroup =  document.documentID
                    self.groupArray.append(newGroup)
                }
            }
        }
    }
    
    func fetchGroupMember(){
        let docName = forLabel.text!
        db.collection("SelectYourGroup").document("\(docName)!").getDocument { (querySnapshot, err) in
            if let err = err
            {
                print("Error getting documents: \(err)");
            }
            else
            {
                var count = 0
                for _ in querySnapshot!.documentID {
                    count = count + 1
                    self.numberOfUser = count
                }
            }
            self.getUserName()
        }
    }
    func getUserName(){
        db.collection("SelectYourGroup").getDocuments(completion: { (QuerySnapShot, error) in
            self.groupInfoArray.removeAll()
            
            for document in QuerySnapShot!.documents {
                if self.forLabel.text! ==  document.documentID {
                    
                    self.activityIndicator.center = self.view.center
                    self.activityIndicator.hidesWhenStopped = true
                    self.activityIndicator.style = UIActivityIndicatorView.Style.gray
                    self.view.addSubview(self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    
                    self.db.collection("UserSignUp").getDocuments() { (QuerySnapshot, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else {
                            for document in (QuerySnapshot?.documents)! {
                                if self.PaidByLabel.text == (document.data()["userName"] as! String) {
                                    self.paidByEmail = (document.data()["email"] as! String)
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                        }
                    }
                    
                    self.numberOfUser = Int(document.data()["totalMember"] as! Int)
                    for i in 1..<self.numberOfUser {
                        let groupInfo = GroupData()
                        let username = "userName\(i)"
                        let email = "email\(i)"
                        groupInfo.groupUserName = (document.data()["\(username)"] as! String)
                        let usrEmail = (document.data()["\(email)"] as! String)
                        self.userPickerArray["\(email)"] = usrEmail
                        
                        if self.totalAmountOfBill.text != "" {
                            let amount = Int(self.totalAmountOfBill.text!)! / self.numberOfUser
                            groupInfo.moneyArray = String(amount)
                            
                            self.rupeeArray.append(amount)
                            self.groupInfoArray.append(groupInfo)
                        }
                        else {
                            let alert = UIAlertController(title: "Oops!", message: "Please enter total amount of bill", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true , completion: nil)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func upArrow(_ sender: UIButton) {
        splitManually.text = "Split Equally"
        
        if totalAmountOfBill.text != "" {
            self.groupInfoArray.removeAll()
            getUserName()
        }
        else {
            let alert = UIAlertController(title: "Oops!", message: "Please enter total amount of bill", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true , completion: nil)
        }
        
    }
    
    @IBAction func downArrow(_ sender: UIButton) {
        splitManually.text = "Split Unequally"
        
        if totalAmountOfBill.text != "" {
            self.groupInfoArray.removeAll()
            
            db.collection("SelectYourGroup").getDocuments(completion: { (QuerySnapShot, error) in
                var Amt = Int(self.totalAmountOfBill.text!)!
                
                
                for document in QuerySnapShot!.documents {
                    if self.forLabel.text! ==  document.documentID {
                        
                        for i in 1..<self.numberOfUser {
                            let groupInfo = GroupData()
                            
                            
                            groupInfo.groupUserName = (document.data()["userName\(i)"] as! String)
                            self.userPickerArray["email\(i)"] = (document.data()["email\(i)"] as! String)
                            let  n = self.numberOfUser + 2
                            let  m = self.numberOfUser + 6
                            
                            let number = Int.random(in: n...m)
                            let amount = Amt / number
                            
                            groupInfo.moneyArray = String(amount)
                            
                            let totalValue =  Amt - amount
                            Amt = totalValue
                            self.groupInfoArray.append(groupInfo)
                        }
                        
                        self.tableView.reloadData()
                    }
                }
                self.tableView.reloadData()
            })
        }
        else {
            let alert = UIAlertController(title: "Oops!", message: "Please enter total amount of bill", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true , completion: nil)
        }
    }
    
    @IBAction func selectGroup(_ sender: UIButton) {
        tag = 0
        
        self.userPickerView = UIPickerView(frame:CGRect(x: 100, y: 280, width: 250 , height: 150))
        self.userPickerView.delegate = self
        self.userPickerView.dataSource = self
        self.userPickerView.backgroundColor = UIColor.white
        self.userPickerView.selectRow(selectedGroupRow, inComponent: 0, animated: true)
        self.view.addSubview(userPickerView)
    }
    
    @IBAction func saveBill(_ sender: UIBarButtonItem) {
        
        if subjectOfBill.text ==  "" || totalAmountOfBill.text == "" || forLabel.text == "" {
            let alert = UIAlertController(title: "Oops!", message: "Please enter total amount of bill", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true , completion: nil)
        }
        else {
            if UserDefaults.standard.string(forKey: "currency") == "INR" {
                totalAmount = Int(totalAmountOfBill.text!)! / 70
                
                for i in 0..<rupeeArray.count{
                    let rupeeValue = rupeeArray[i]
                    let dolarValue = Int(rupeeValue) / 70
                    dolarArray.append(dolarValue)
                }
            }
            else if UserDefaults.standard.string(forKey: "currency") == "USD" {
                totalAmount = Int(totalAmountOfBill.text!)!
                
                for i in 0..<rupeeArray.count{
                    let dolarValue = rupeeArray[i]
                    
                    dolarArray.append(dolarValue)
                }
            }
            userInfo()
            saveTheBill(users: userPickerArray)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as!  TabBarViewController
            navigationController?.pushViewController(vc, animated:true)
        }
    }
    
    func userInfo() {
        let user = Auth.auth().currentUser!.email!
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        
        let currentTime = Calendar.current.dateComponents([.day,.year], from: Date.init())
        let date : Int = currentTime.day!
        let month = dateFormatter.string(from: now)
        let year : Int = currentTime.year!
        let timeData = "\(date) \(month), \(year)"
        
        let docData: [String: Any] = ["subjectOfBill": "\(subjectOfBill.text!)","totalAmountOfBill":  totalAmount ,"paidBy": "\(paidByEmail!)",
            "paidFor": "\(forLabel.text!)","currentUser": "\(user)","splitManner":"\(splitManually.text!)","Time": timeData]
        
        db.collection("userInfo").document("\(user)").collection("billInfo").document().setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
            else {
                print("Document successfully written!")
            }
        }
    }
    
    func saveTheBill (users: [String:String]){
        for i in 0..<userPickerArray.count {
            
            let m = i + 1
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            
            let currentTime = Calendar.current.dateComponents([.year], from: Date.init())
            let month = dateFormatter.string(from: now)
            let year : Int = currentTime.year!
            let timeData = "\(month) \(year)"
            
            let docData: [String: Any] = ["Subject": "\(subjectOfBill.text!)" ,"name": userPickerArray["email\(m)"]!, "money" : dolarArray[i],
                                          "paidBy": "\(paidByEmail!)","totalAmount": totalAmount!, "Month" : timeData ]
            db.collection("PeopleWhoOweYou").document().setData(docData) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
                else {
                    print("Document successfully written!")
                }
            }
        }
    }
}
extension AddBillViewController : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.userLabel.text = groupInfoArray[indexPath.row].groupUserName
        cell.prizeLabel.text = groupInfoArray[indexPath.row].moneyArray
        return cell
    }
}

//MARK: Pickerview method for Select Group & userName
extension AddBillViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if tag == 1 {
            return paidByArray.count
        } else {
            return groupArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if tag == 1 {
            return paidByArray[row]
        } else {
            return groupArray[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if tag == 1{
            selectedGroupRow = row
            PaidByLabel.text = paidByArray[row]
            selectedGroup = row
            userPickerView.isHidden = true
            tableView.reloadData()
        }
        else {
            selectedGroupRow = row
            forLabel.text = groupArray[row]
            selectedGroup = row
            fetchGroupMember()
            userPickerView.isHidden = true
            tableView.reloadData()
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}
