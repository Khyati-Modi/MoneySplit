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
        
        db.collection("userInfo").getDocuments { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else  {
                for document in QuerySnapshot!.documents {
                    if self.paidByUser == document.documentID {
                        self.subjectOfBill.text = (document.data()["subjectOfBill"] as! String)
                        self.amountOfBill.text = (document.data()["totalAmountOfBill"] as! String)
                        self.addedByDate.text = (document.data()["Time"] as! String)
                        self.paidBy.text = (document.data()["paidBy"] as! String)
                        self.paidFor.text = (document.data()["paidFor"] as! String)
                        self.splittedType.text = (document.data()["splitManner"] as! String)
                    }
                }
            }
        }
    }
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
