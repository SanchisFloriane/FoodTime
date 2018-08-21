//
//  MyListTripsTableViewCell.swift
//  FoodTime
//
//  Created by bob on 8/20/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import iCarousel

class MyListTripsTableViewCell: UITableViewCell {

    @IBOutlet weak var CarouselTrip: CarouselTrips!
    @IBOutlet weak var TitleTrip: UILabel!
    
    //Data not in the view
    var idTrip : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CarouselTrip.type = .linear
        CarouselTrip.centerItemWhenSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
