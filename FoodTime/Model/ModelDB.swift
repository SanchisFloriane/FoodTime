//
//   static let swift
//  FoodTime
//
//  Created by bob on 7/25/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation

class ModelDB {
    
    static let folderProfilePictureUserDB : String = "profileImages"
    
    //Fields in DB
    static let tastes : String = "tastes"
    static let typeFood : String = "typeFood"
    static let typeDrink : String = "typeDrink"
    static let typePlace : String = "typePlace"
    static let settings : String = "settings"
    static let users : String = "users"
    
    //PLACE
    static let Place_name : String = "name"
    static let Place_typePlace : String = "typePlace"
    static let Place_typeFood : String = "typeFood"
    static let Place_typeDrink: String = "typeDrink"
    static let Place_rating : String = "rating"
    static let Place_priceLevel : String = "priceLevel"
    static let Place_menu : String = "menu"
    static let Place_website : String = "website"
    static let Place_phoneNumber: String = "phoneNumber"
    static let Place_openingHours : String = "openingHours"
    static let Place_address : String = "address"
    static let Place_city : String = "city"
    static let Place_state : String = "state"
    static let Place_zipCode: String = "zipCode"
    static let Place_country : String = "country"
    static let Place_photosLink : String = "photosLink"
    static let Place_icon : String = "icon"
    
    //TASTES
    static let Tastes_typeDrinkPlace : String = "typeDrinkPlace"
    static let Tastes_typeFoodPlace : String = "typeFoodPlace"
    static let Tastes_typeDrink : String = "typeDrink"
    static let Tastes_typeFood : String = "typeFood"
    
    //SETTINGS
    static let Settings_isNotified : String = "isNotified"
    static let Settings_homeCountry : String = "homeCountry"
    static let Settings_homeSate : String = "homeSate"
    static let Settings_homeCity : String = "homeCity"
    static let Settings_homeZipCode : String = "homeZipCode"
    static let Settings_workCountry : String = "workCountry"
    static let Settings_workSate : String = "workSate"
    static let Settings_workCity : String = "workCity"
    static let Settings_workZipCode : String = "workZipCode"
    
    //USER
    static let User_lastname : String = "lastname"
    static let User_firstname : String =  "firstname"
    static let User_pseudo : String =  "pseudo"
    static let User_email : String =  "email"
    static let User_profilePictureFIRUrl : String = "profilePictureFIRUrl"
    static let User_fbAccount : String = "fbAccount"
    static let User_googleAccount : String = "googleAccount"
    
    
}
