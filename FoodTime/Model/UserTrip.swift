//
//  UserTrip.swift
//  FoodTime
//
//  Created by bob on 8/14/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit

class UserTrip {
    
    //Attributes in DB
    var idUser: String?
    var idTrip: String?
    
    //Attributes no in DB
    
    init() {}
    
    init(idUser: String?, idTrip: String?) {
        
        self.idUser = idUser
        self.idTrip = idTrip
    }
    
    func getData() -> [String: String]
    {
        return [ModelDB.UserTrip_idUser: self.idUser ?? "",
                ModelDB.UserTrip_idTrip : self.idTrip ?? ""]
    }
}
