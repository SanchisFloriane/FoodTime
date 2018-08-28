//
//  Trip.swift
//  FoodTime
//
//  Created by bob on 8/14/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit

class Trip {
    
    //Attributes in DB
    var idTrip: String?
    var name: String?
    var startDate: Date?
    var endDate: Date?
    
    //Attributes no in DB
    var placeList : [Place] = [Place]()
    
    init() {}
    
    init(idTrip: String?, name: String?, startDate: Date?, endDate: Date?) {
        
        self.idTrip = idTrip
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func getData() -> [String: String]
    {
        return [ModelDB.Trip_name: self.name ?? "",
                ModelDB.Trip_startDate : self.startDate?.description ?? "",
                ModelDB.Trip_endDate : self.endDate?.description ?? ""]
    }
}
