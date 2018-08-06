//
//  SearchPlaceTableViewCell.swift
//  FoodTime
//
//  Created by floriane sanchis on 31/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class SearchPlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var addressPlaceLbl: UILabel!
    @IBOutlet weak var distancePlaceLbl: UILabel!
    @IBOutlet weak var namePlaceLbl: UILabel!
    
    var placeId : String = ""
    var isLocationCell : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
