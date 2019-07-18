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
    
    var groupInfoArray = [GroupData]()
    
    let storage = Storage.storage()
    var db: Firestore!
    
    var userPickerView : UIPickerView!
    var selectedGroup : Int!
    
    var groupArray : [String] = []
    
    var numberOfUser = 0
    var selectedGroupRow : Int = 0
    var userPickerArray : [String : String] = [:]
    
    var totalAmount : Int!
    var rupeeArray : [Int] = []
    var dolarArray : [Int] = []

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subjectOfBill: UITextField!
    @IBOutlet weak var totalAmountOfBill: UITextField!
    @IBOutlet weak var paidByTextField: UITextField!
    @IBOutlet weak var fortextField: UITextField!
    @IBOutlet weak var splitManually: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectOfBill.text = ""
        totalAmountOfBill.text = ""
        paidByTextField.text = ""
        fortextField.text = ""
        
        let currencyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        var currencyImage : UIImage!

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
        
        paidByTextField.text = Auth.auth().currentUser?.email
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        fetchGroupArray()
    }
    
    func fetchGroupArray(){
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
        db.collection("selectYourGroup").getDocuments() { (QuerySnapshot, err) in
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
        let docName = fortextField.text!
        db.collection("selectYourGroup").document("\(docName)!").getDocument { (querySnapshot, err) in
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
        db.collection("selectYourGroup").getDocuments(completion: { (QuerySnapShot, error) in
            self.groupInfoArray.removeAll()
            
            for document in QuerySnapShot!.documents {
                if self.fortextField.text! ==  document.documentID {
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
            
            db.collection("selectYourGroup").getDocuments(completion: { (QuerySnapShot, error) in
                var Amt = Int(self.totalAmountOfBill.text!)!

                
                for document in QuerySnapShot!.documents {
                    if self.fortextField.text! ==  document.documentID {

                        for i in 1..<self.numberOfUser {
                            let groupInfo = GroupData()
                            

                            groupInfo.groupUserName = (document.data()["userName\(i)"] as! String)
                            self.userPickerArray["email\(i)"] = (document.data()["email\(i)"] as! String)
                            print(Amt)
                            let  n = self.numberOfUser + 2
                            let  m = self.numberOfUser + 6
                            
                            let number = Int.random(in: n...m)
                            let amount = Amt / number
                    
                            groupInfo.moneyArray = String(amount)
                            
                            let totalValue =  Amt - amount
                            print(Amt)
                            Amt = totalValue
                            print(Amt)
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
        self.userPickerView = UIPickerView(frame:CGRect(x: 100, y: 280, width: 250 , height: 150))
        self.userPickerView.delegate = self
        self.userPickerView.dataSource = self
        self.userPickerView.backgroundColor = UIColor.white
        self.userPickerView.selectRow(selectedGroupRow, inComponent: 0, animated: true)
        self.view.addSubview(userPickerView)
    }
    
    @IBAction func saveBill(_ sender: UIBarButtonItem) {
      
        if subjectOfBill.text ==  "" || totalAmountOfBill.text == "" || fortextField.text == "" {
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
                    print(dolarArray)
                }
            }
            else if UserDefaults.standard.string(forKey: "currency") == "USD" {
                totalAmount = Int(totalAmountOfBill.text!)!
                
                for i in 0..<rupeeArray.count{
                    let dolarValue = rupeeArray[i]
                    
                    dolarArray.append(dolarValue)
                    print(dolarArray)
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
        
        
        let docData: [String: Any] = ["subjectOfBill": "\(subjectOfBill.text!)","totalAmountOfBill":  totalAmount ,"paidBy": "\(paidByTextField.text!)",
                    "paidFor": "\(fortextField.text!)","currentUser": "\(user)","splitManner":"\(splitManually.text!)","Time": timeData]
        
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
            
            print(subjectOfBill.text!)
            let m = i + 1
            print(userPickerArray["email\(m)"]!)
            print(dolarArray[i])
            print(paidByTextField.text!)
            print(totalAmount!)

            
            let docData: [String: Any] = ["Subject": "\(subjectOfBill.text!)" ,"name": userPickerArray["email\(m)"]!, "money" :  dolarArray[i],
                                          "paidBy": "\(paidByTextField.text!)","totalAmount": totalAmount!]
            
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

//MARK: Select Your Group
extension AddBillViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1

    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return  groupArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGroupRow = row
        fortextField.text = groupArray[row]
        selectedGroup = row
        fetchGroupMember()
        userPickerView.isHidden = true
        tableView.reloadData()
    }
}
