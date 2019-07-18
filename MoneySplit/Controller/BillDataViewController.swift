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
        
        
        self.db.collection("userInfo").document(self.addedByUserName).collection("billInfo").getDocuments { (QuerySnapShot, err) in
            if let err = err{
                print(err.localizedDescription)
            }
            else{
                for document in (QuerySnapShot!.documents) {
                    let user = self.paidByUser!

                    self.subjectOfBill.text = (document.data()["subjectOfBill"] as! String)
                    var amt = ""
                    if UserDefaults.standard.string(forKey: "currency") == "INR"{
                        let rupees = (document.data()["totalAmountOfBill"] as! Int)
                        let IntRupees = Int(rupees)
                        amt = Conversion.shared.convertCurrency(dollarAmount: IntRupees)
                    }
                    else {
                        amt =  ("\(document.data()["totalAmountOfBill"] as! String) $")
                    }
                    
                    self.amountOfBill.text = "\(amt)"

                    self.addedByDate.text = ("Added by \(user) on \(document.data()["Time"] as! String)")
                    self.paidBy.text = ("Paid by \(user)")
                    self.paidFor.text = ("For \(document.data()["paidFor"] as! String)")
                    self.splittedType.text = (document.data()["splitManner"] as! String)
                }
            }
        }
    }
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
