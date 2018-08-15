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
    var isLiked: Bool?
    var toTest: Bool?
    
    //Attributes no in DB
    
    init() {}
    
    init(idUser: String?, idPlace: String?, idTrip: String?, isLiked: Bool?, toTest: Bool?) {
        
        self.idUser = idUser
        self.idPlace = idPlace
        self.idTrip = idTrip
        self.isLiked = isLiked
        self.toTest = toTest
    }
    
    func getData() -> [String: String]
    {
        return [ModelDB.UserPlace_isLiked: self.isLiked?.description ?? "false",
                ModelDB.UserPlace_toTest : self.toTest?.description ?? "false"]
    }
}
