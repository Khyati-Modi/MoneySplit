//
//  BillDataViewController.swift
//  MoneySplit
//
//  Created by Khyati Modi on 16/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit
import Firebase

class BillDataViewController: UIViewController {
    
    var selectedItem : String!
    var paidByUser : String!
    var db : Firestore!
    var sender = ""
    var paidby = ""
    var addedByUserName = ""
    var a = 0
    var addedby : String = ""

    @IBOutlet weak var subjectOfBill: UILabel!
    @IBOutlet weak var amountOfBill: UILabel!
    @IBOutlet weak var addedByDate: UILabel!
    @IBOutlet weak var paidBy: UILabel!
    @IBOutlet weak var paidFor: UILabel!
    @IBOutlet weak var splittedType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        getaddName()
    }
    
    func getaddName() {
        self.db.collection("userInfo").document(self.addedByUserName).collection("billInfo").getDocuments { (QuerySnapShot, err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                for document in (QuerySnapShot!.documents) {
                    if self.selectedItem == (document.data()["subjectOfBill"] as! String) {
                        let add = Auth.auth().currentUser?.email!
                        if Auth.auth().currentUser?.email! == (document.data()["currentUser"] as! String){
                            self.addedby = "You"
                            self.data()
                        }
                        else {
                            self.db.collection("UserSignUp").getDocuments(completion: { (QuerySnapshot, Error) in
                                if let Error = Error{
                                    print(Error.localizedDescription)
                                }
                                else {
                                    for document in (QuerySnapshot?.documents)!{
                                        if add == document.documentID {
                                            self.addedby = (document.data()["userName"] as! String)
                                            self.data()
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func data(){
        self.db.collection("userInfo").document(self.addedByUserName).collection("billInfo").getDocuments { (QuerySnapShot, err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                for document in (QuerySnapShot!.documents) {
                    var amt = ""
                    if self.selectedItem == (document.data()["subjectOfBill"] as! String) {
                        let userName = self.paidByUser!
                        let userNameArray = userName.components(separatedBy: " ")
                        let firstName: String = userNameArray[0]
                        let user = firstName
                        self.subjectOfBill.text = (document.data()["subjectOfBill"] as! String)
                        
                        if UserDefaults.standard.string(forKey: "currency") == "INR"{
                            let rupees = (document.data()["totalAmountOfBill"] as! Int)
                            let IntRupees = Int(rupees)
                            amt = Conversion.shared.convertCurrency(dollarAmount: IntRupees)
                        }
                        else {
                            amt =  ("\(document.data()["totalAmountOfBill"] as! Int) $")
                        }
                        self.amountOfBill.text = "\(amt)"
                        self.addedByDate.text = ("Added by \(String(describing: self.addedby)) on \(document.data()["Time"] as! String)")
                        self.paidBy.text = ("Paid by \(user)")
                        self.paidFor.text = ("For \(document.data()["paidFor"] as! String)")
                        
                        if (document.data()["splitManner"] as! String) == "Split Equally"{
                            self.splittedType.text = "Splitted equally"
                        }
                        else{
                            self.splittedType.text = "Splitted unequally"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
