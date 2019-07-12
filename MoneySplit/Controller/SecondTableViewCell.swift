//
//  SecondTableViewCell.swift
//  MoneySplit
//
//  Created by Khyati Modi on 12/07/19.
//  Copyright © 2019 Khyati Modi. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var peopleNameLabel: UILabel!
    @IBOutlet weak var prizeLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
