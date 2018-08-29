//
//  UserHPlace.swift
//  FoodTime
//
//  Created by floriane sanchis on 8/29/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit

class UserHPlace {
    
    //Attributes in DB
    var idUser: String?
    var idPlace: String?
    
    //Attributes no in DB
    
    init() {}
    
    init(idUser: String?, idPlace: String?) {
        
        self.idUser = idUser
        self.idPlace = idPlace
    }
}
