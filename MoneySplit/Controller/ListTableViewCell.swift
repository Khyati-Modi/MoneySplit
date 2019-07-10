//
//  ListTableViewCell.swift
//  MoneySplit
//
//  Created by Khyati Modi on 08/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var amountOutlet: UIButton!
    
    @IBAction func amountButton(_ sender: UIButton) {
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
