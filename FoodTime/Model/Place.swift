//
//  File.swift
//  FoodTime
//
//  Created by floriane sanchis on 02/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation

class Place
{
    //Attributes in DB
    var name : String?
    var typePlace : [String?] = [String?]()
    var typeFood: String?
    var typeDrink : String?
    var rating : String?
    var priceLevel : String?
    var menu : String?
    var website : String?
    var phoneNumber : String?
    var openingHours : String?
    var address : String?
    var city : String?
    var state : String?
    var zipCode : String?
    var country : String?
    var photosLink : [String?] = [String?]()
    var icon : String?
    
    //Attributes no in DB
    var idPlace: String?
    var openNow: Bool = false
    var formattedAddress: String?
    
    init() {}
    
    init(idPlace: String?, name: String?, typePlace: [String?], typeFood: String?, typeDrink: String?, rating: String?, priceLevel: String?, menu: String?, website: String?, phoneNumber: String?, openingHours: String?, address: String?, city: String?, state: String?, zipCode: String?, country: String?, photosLink: [String?], icon: String?, openNow: Bool, formattedAddress: String?) {
        
        self.idPlace = idPlace
        self.name = name
        self.typePlace = typePlace
        self.typeFood = typeFood
        self.typeDrink = typeDrink
        self.rating = rating
        self.priceLevel = priceLevel
        self.menu = menu
        self.website = website
        self.phoneNumber = phoneNumber
        self.openingHours = openingHours
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.photosLink = photosLink
        self.icon = icon
        self.formattedAddress = formattedAddress
    }
    
    func getData() -> [String: Any]
    {
        return [ModelDB.Place_name: self.name ?? "",
                ModelDB.Place_typePlace: self.typePlace,
                ModelDB.Place_typeFood : self.typeFood ?? "",
                ModelDB.Place_typeDrink: self.typeDrink ?? "",
                ModelDB.Place_rating : self.rating ?? "",
                ModelDB.Place_priceLevel : self.priceLevel ?? "",
                ModelDB.Place_menu : self.menu ?? "",
                ModelDB.Place_website : self.website ?? "",
                ModelDB.Place_phoneNumber: self.phoneNumber ?? "",
                ModelDB.Place_openingHours : self.openingHours ?? "",
                ModelDB.Place_address : self.address ?? "",
                ModelDB.Place_city : self.city ?? "",
                ModelDB.Place_state : self.state ?? "",
                ModelDB.Place_zipCode: self.zipCode ?? "",
                ModelDB.Place_country : self.country ?? "",
                ModelDB.Place_photosLink : self.photosLink,
                ModelDB.Place_icon : self.icon ?? ""
        ]
    }
    
}
