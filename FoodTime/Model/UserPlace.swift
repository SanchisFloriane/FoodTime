//
//  UserPlace.swift
//  FoodTime
//
//  Created by bob on 8/8/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit

class UserPlace {
    
    //Attributes in DB
    var idUser: String?
    var idPlace: String?
    var idTrip: String?
    
    //Attributes no in DB
    
    init() {}
    
    init(idUser: String?, idPlace: String?, idTrip: String?) {
        
        self.idUser = idUser
        self.idPlace = idPlace
        self.idTrip = idTrip
    }    
}
