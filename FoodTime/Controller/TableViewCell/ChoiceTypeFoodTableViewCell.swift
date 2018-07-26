//
//  ChoiceTypeFoodTableViewCell.swift
//  FoodTime
//
//  Created by bob on 7/25/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import UICheckbox_Swift

class ChoiceTypeFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkbox: UICheckbox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
