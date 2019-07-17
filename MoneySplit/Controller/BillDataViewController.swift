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
        
        if sender == "user" {
            print( self.paidByUser!)

            db.collection("UserSignUp").getDocuments { (QuerySnap, Error) in

                print("inside database")
                if let Error = Error {
                    print(Error.localizedDescription)
                }
                else{
                    print("Inside Else")
                    for document in (QuerySnap!.documents) {
                        if (document.data()["fullName"] as! String) == self.paidByUser! {
                            
                            self.paidby = document.documentID
                        }
                    }
                }
            }
        }
        else {
             paidby = paidByUser
        }
        
        print("here paidby = \(paidby)")
        
        db.collection("userInfo").document(paidby).collection("billInfo").getDocuments { (QuerySnapShot, err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                for document in (QuerySnapShot!.documents) {
                    self.subjectOfBill.text = (document.data()["subjectOfBill"] as! String)
                    self.amountOfBill.text = ("\(document.data()["totalAmountOfBill"] as! String) $")
                    self.addedByDate.text = String(document.data()["Time"] as! Int)
                    self.paidBy.text = (document.data()["paidBy"] as! String)
                    self.paidFor.text = (document.data()["paidFor"] as! String)
                    self.splittedType.text = (document.data()["splitManner"] as! String)
                }
            }
        }
    }
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
