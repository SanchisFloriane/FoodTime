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
    static let trips : String = "trips"
    static let typeFood : String = "typeFood"
    static let typeDrink : String = "typeDrink"
    static let typePlace : String = "typePlace"
    static let settings : String = "settings"
    static let users : String = "users"
    static let user_hplace : String = "user_hplace"
    static let user_place : String = "user_place"
    static let user_trip : String = "user_trip"
    
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
    
    //TASTES
    static let Tastes_typeDrinkPlace : String = "typeDrinkPlace"
    static let Tastes_typeFoodPlace : String = "typeFoodPlace"
    static let Tastes_typeDrink : String = "typeDrink"
    static let Tastes_typeFood : String = "typeFood"
    
    //TRIP
    static let Trip_idTrip : String = "idTrip"
    static let Trip_name : String = "name"
    static let Trip_startDate : String = "startDate"
    static let Trip_endDate : String = "endDate"
    
    //USER
    static let User_lastname : String = "lastname"
    static let User_firstname : String = "firstname"
    static let User_pseudo : String = "pseudo"
    static let User_email : String = "email"
    static let User_profilePictureFIRUrl : String = "profilePictureFIRUrl"
    static let User_fbAccount : String = "fbAccount"
    static let User_googleAccount : String = "googleAccount"
    
    //USERPLACE
    static let UserPlace_idUser : String = "idUser"
    static let UserPlace_idPlace : String = "idPlace"
    static let UserPlace_idTrip : String = "idTrip"
    static let UserPlace_isLiked : String = "isLiked"
    static let UserPlace_toTest : String = "toTest"
    
    //USERTRIP
    static let UserTrip_idUser : String = "idUser"
    static let UserTrip_idTrip : String = "idTrip"
    
}
