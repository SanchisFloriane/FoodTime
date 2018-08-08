//
//  PlacePhoto.swift
//  FoodTime
//
//  Created by bob on 8/7/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation

class PlacePhoto
{
    var photo_reference : String?
    var html_attributions : [String?] = [String?]()
    var height : Int?
    var width : Int?
    
    init() {}
    
    init(photo_reference: String?, html_attributions: [String?], height: Int?, width: Int?) {
        
        self.photo_reference = photo_reference
        self.html_attributions = html_attributions
        self.height = height
        self.width = width
    }
    
}
