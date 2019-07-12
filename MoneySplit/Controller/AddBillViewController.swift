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
    
    
    let storage = Storage.storage()
    var db: Firestore!
    
    var userPickerView : UIPickerView!
    var selectedGroup : Int!
    let groupArray = ["Saheb & Khyati","Khyati & Dharmik","Saheb & Dharmik"]
    let groupArray0 = ["Saheb","Khyati"]
    let groupArray1 = ["Khyati","Dharmik"]
    let groupArray2 = ["Saheb","Dharmik"]
    var selectedGroupRow : Int = 0

    var prizeArray = ["",""]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subjectOfBill: UITextField!
    @IBOutlet weak var totalAmountOfBill: UITextField!
    @IBOutlet weak var paidByTextField: UITextField!
    @IBOutlet weak var fortextField: UITextField!
    @IBOutlet weak var splitManually: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currencyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        let currencyImage = UIImage(named: "Currency")
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
    }
    
    @IBAction func upArrow(_ sender: UIButton) {
        splitManually.text = "Split Equally"
        if totalAmountOfBill.text != "" {
            let amount = Double(totalAmountOfBill.text!)! / 3
            prizeArray = ["\(amount)","\(amount)"]
            tableView.reloadData()
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
            let number = Int.random(in: 3 ..< 10)
            let amount = (Double(totalAmountOfBill.text!)! / Double(number) )
            
            let secondAmount = Double(totalAmountOfBill.text!)!  - amount
            let randomNumber = Int.random(in: 3 ..< 10)
            let secondValue = (Double(secondAmount) / Double(randomNumber))
//            let thirdAmount = secondAmount - secondValue
            
            prizeArray = ["\(String(format:"%.2f", amount))","\(String(format:"%.2f", secondValue))"]
            tableView.reloadData()
        }
    
        else {
            let alert = UIAlertController(title: "Oops!", message: "Please enter total amount of bill", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true , completion: nil)
        }
    
    }
    
    @IBAction func selectGroup(_ sender: UIButton) {
        self.userPickerView = UIPickerView(frame:CGRect(x: 180, y: 253, width: 200 , height: 150))
        self.userPickerView.delegate = self
        self.userPickerView.dataSource = self
        self.userPickerView.backgroundColor = UIColor.white
        self.userPickerView.selectRow(selectedGroupRow, inComponent: 0, animated: true)
        self.view.addSubview(userPickerView)
        
    }
    
    @IBAction func saveBill(_ sender: UIBarButtonItem) {
        addBill()
        addPeopleWhoOweYou()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as!  TabBarViewController
        navigationController?.pushViewController(vc, animated:true)
    }
    
    func addBill() {
        let user = Auth.auth().currentUser!.email!
        
        let docData: [String: Any] = ["subjectOfBill": "\(subjectOfBill.text!)","totalAmountOfBill": "\(totalAmountOfBill.text!)","paidBy": "\(paidByTextField.text!)",
            "paidFor": "\(fortextField.text!)","currentUser": "\(user)","splitManner":"\(splitManually.text!)","ShareWith1": "\(prizeArray[0])","ShareWith2": "\(prizeArray[1])"]
        
        
        db.collection("UserInfo").document("\(user)").collection("billInfo").document().setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
            else {
                print("Document successfully written!")
            }
        }
    }
    func addPeopleWhoOweYou(){
        let pickTheUser = Auth.auth().currentUser?.email

        switch pickTheUser {
        case "khyati.modi.sa@gmail.com" :
            callTheUser(userOne: "sahebsingh.tuleja.sa@gmail.com", userTwo: "dharmik.dalwadi.sa@gmail.com")
        case "dharmik.dalwadi.sa@gmail.com" :
            callTheUser(userOne: "sahebsingh.tuleja.sa@gmail.com", userTwo: "khyati.modi.sa@gmail.com")
        case "sahebsingh.tuleja.sa@gmail.com" :
            callTheUser(userOne: "khyati.modi.sa@gmail.com", userTwo: "dharmik.dalwadi.sa@gmail.com")
        default:
            print("Oooopsss!")
        }
    }
    func callTheUser (userOne : String, userTwo : String){
        let docData: [String: Any] = ["Subject": "\(subjectOfBill.text!)" ,"name": userOne ,"money": "\(prizeArray[0])","paidBy": "\(paidByTextField.text!)"]
        
        db.collection("PeopleWhoOweYou").document().setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
            else {
                print("Document successfully written!")
            }
        }
        
        let secondDocData: [String: Any] = ["Subject": "\(subjectOfBill.text!)" ,"name": userTwo ,"money": "\(self.prizeArray[1])","paidBy": "\(paidByTextField.text!)"]
    
        self.db.collection("PeopleWhoOweYou").document().setData(secondDocData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            }
            else {
                print("Document successfully written!")
            }
        }
    }
}
    
extension AddBillViewController : UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if selectedGroup == 0 {
          cell.userLabel.text = groupArray0[indexPath.row]
        }
        else  if selectedGroup == 1 {
            cell.userLabel.text = groupArray1[indexPath.row]
        }
        else  if selectedGroup == 2 {
            cell.userLabel.text = groupArray2[indexPath.row]
        }
        cell.prizeLabel.text = prizeArray[indexPath.row]
        return cell
    }
}


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
        userPickerView.isHidden = true
        tableView.reloadData()
    }
}
