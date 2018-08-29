//
//  MyListPlaceRecentlyViewedTableViewCell.swift
//  FoodTime
//
//  Created by floriane sanchis on 8/29/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class MyListPlaceRecentlyViewedTableViewCell: UITableViewCell {

    @IBOutlet weak var addressPlace: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var namePlace: UILabel!
    
    
    //Data not in the view
    var idPlace : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
