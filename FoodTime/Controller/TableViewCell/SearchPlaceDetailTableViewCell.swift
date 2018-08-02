//
//  SearchPlaceDetailTableViewCell.swift
//  FoodTime
//
//  Created by floriane sanchis on 01/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class SearchPlaceDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var addressPlaceLbl: UILabel!
    @IBOutlet weak var distancePlaceLbl: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var namePlaceLbl: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var typePlaceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
