//
//  Conversion.swift
//  MoneySplit
//
//  Created by Khyati Modi on 18/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import Foundation

class Conversion {
    
    static let shared = Conversion()
    
    func convertCurrency(dollarAmount : Int) -> String{
       let rupeeAmount = dollarAmount * 70
        return ("\(rupeeAmount)₹")
    }
}
