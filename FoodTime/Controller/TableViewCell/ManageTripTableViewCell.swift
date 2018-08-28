//
//  ManageTripTableViewCell.swift
//  FoodTime
//
//  Created by floriane sanchis on 27/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class ManageTripTableViewCell: UITableViewCell {

    @IBOutlet weak var adresseTripLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var imageTrip: UIImageView!
    @IBOutlet weak var nameTripLbl: UILabel!
    
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
