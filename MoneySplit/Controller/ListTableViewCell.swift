//
//  ListTableViewCell.swift
//  MoneySplit
//
//  Created by Khyati Modi on 08/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var amountButtonOutlet: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func amountButton(_ sender: UIButton) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 35
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
