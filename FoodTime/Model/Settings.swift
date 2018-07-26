//
//  Settings.swift
//  FoodTime
//
//  Created by bob on 7/26/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//


import Foundation
import UIKit

class Settings {
    
    //Attributes in DB
    var isNotified: String! = "false"
    var homeCountry: String?
    var homeState: String?
    var homeAddress: String?
    var homeCity: String?
    var homeZipCode: String?
    var workCountry: String?
    var workState: String?
    var workAddress: String?
    var workCity: String?
    var workZipCode: String?
    
    init() {}
    
    init(isNotified: String,homeCountry: String?,homeState: String?,homeAddress: String?,homeCity: String?,homeZipCode: String?, workCountry: String?, workState: String?, workAddress: String?, workCity: String?, workZipCode: String?) {
        
        self.isNotified = isNotified
        self.homeCountry = homeCountry
        self.homeState = homeState
        self.homeAddress = homeAddress
        self.homeCity = homeCity
        self.homeZipCode = homeZipCode
        self.workCountry = workCountry
        self.workState = workState
        self.workAddress = workAddress
        self.workCity = workCity
        self.workZipCode = workZipCode
    }
    
    func getData() -> [String: String]
    {
        return [ModelDB.Settings_isNotified: self.isNotified,
                                ModelDB.Settings_homeCountry: self.homeCountry ?? "",
                                ModelDB.Settings_homeSate : self.homeState ?? "",
                                ModelDB.Settings_homeCity : self.homeCity ?? "",
                                ModelDB.Settings_homeZipCode : self.homeZipCode ?? "",
                                ModelDB.Settings_workCountry : self.workCountry ?? "",
                                ModelDB.Settings_workSate : self.workState ?? "",
                                ModelDB.Settings_workCity : self.workCity ?? "",
                                ModelDB.Settings_workZipCode : self.workZipCode ?? ""]
    }
}
