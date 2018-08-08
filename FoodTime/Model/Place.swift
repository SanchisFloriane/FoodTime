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
    var openingHours : [String?] = [String?]()
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
    
    init(idPlace: String?, name: String?, typePlace: [String?], typeFood: String?, typeDrink: String?, rating: String?, priceLevel: String?, menu: String?, website: String?, phoneNumber: String?, openingHours: [String?], address: String?, city: String?, state: String?, zipCode: String?, country: String?, photosLink: [String?], icon: String?, openNow: Bool, formattedAddress: String?) {
        
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
                ModelDB.Place_openingHours : self.openingHours,
                ModelDB.Place_address : self.address ?? "",
                ModelDB.Place_city : self.city ?? "",
                ModelDB.Place_state : self.state ?? "",
                ModelDB.Place_zipCode: self.zipCode ?? "",
                ModelDB.Place_country : self.country ?? "",
                ModelDB.Place_photosLink : self.photosLink,
                ModelDB.Place_icon : self.icon ?? ""
        ]
    }
    
    static func jsonToPlace(tab: [String : Any]?, requestPhoto: Bool, onePlace: Bool, completion:@escaping ([Place])->() )
    {
        var arrayPlace : [Place] = [Place]()
        
        // Parse the json results into an array of Place objects
        var keyResult = "results"
        if onePlace
        {
            keyResult = "result"
        }
        
        var idPlace : String?
        var name : String?
        var formattedAddress : String?
        var rating : Double?
        var priceLevel : Int?
        var website : String?
        var phoneNumber : String?
        var openNow : Bool?
        var icon : String?
        var openingHours : [String?] = [String?]()
        
        if let places = tab?[keyResult] as? [String : Any]
        {
            for place in places
            {
                if place.key == "place_id"
                {
                    idPlace = place.value as? String
                }
                
                if place.key == "name"
                {
                    name = place.value as? String
                }
                
                if place.key == "formatted_address"
                {
                    formattedAddress = place.value as? String
                }
                
                if place.key == "rating"
                {
                    rating = place.value as? Double
                }
                
                if place.key == "price_level"
                {
                    priceLevel = place.value as? Int
                }
                
                if place.key == "website"
                {
                    website = place.value as? String
                }
                
                if place.key == "international_phone_number"
                {
                    phoneNumber = place.value as? String
                }
                
                if place.key == "icon"
                {
                    icon = place.value as? String
                }
                
                if place.key == "opening_hours"
                {
                    let openingHoursJSON = place.value as? [String : Any]
                    if let opennow = openingHoursJSON!["open_now"] as? Bool
                    {
                        openNow = opennow
                    }
                        
                    if let weekdayText = openingHoursJSON!["weekday_text"] as? [String]
                    {
                        for day in weekdayText
                        {
                            openingHours.append(day)
                        }
                    }
                }
                
                var address : String?
                var city : String?
                var state : String?
                var zipCode : String?
                var country : String?
                var route : String?
                var streetNumber : String?
                
                if place.key == "address_components"
                {
                    let addressComponent = place.value as? [[String: Any]]
                
                    for field in addressComponent!
                    {
                        if field["types"] as? [String] == ["street_number"]
                        {
                            streetNumber = field["long_name"] as? String
                        }
                        else if field["types"] as? [String] == ["route"]
                        {
                            route = field["long_name"] as? String
                        }
                        else if field["types"] as? [String] == ["locality"]
                        {
                            city = field["long_name"] as? String
                        }
                        else if field["types"] as? [String] == ["administrative_area_level_1"]
                        {
                            state = field["long_name"] as? String
                        }
                        else if field["types"] as? [String] == ["country"]
                        {
                            country = field["long_name"] as? String
                        }
                        else if field["types"] as? [String] == ["postal_code"]
                        {
                            zipCode = field["long_name"] as? String
                        }
                    }
                    address = "\(streetNumber ?? "") \(route ?? ""))"
                }
                
                var typePlace : [String?] = [String?]()
                if place.key == "types"
                {
                    let typePlaceJSON = place.value as? [String]
                    
                    if typePlaceJSON != nil && !(typePlaceJSON?.isEmpty)!
                    {
                        for placeJSON in typePlaceJSON!
                        {
                            if TypePlace.TypePlaceJSON.findPlaceJSON(typePlaceJSON: placeJSON) != nil
                            {
                                typePlace.append(placeJSON)
                            }
                        }
                    }
                }
                
                var photosLink : [String] = [String]()
                if requestPhoto
                {
                    if place.key == "photos"
                    {
                        let photos = place.value as? [[String : Any]]
                    
                        if photos != nil && !(photos?.isEmpty)!
                        {
                            for photo in photos!
                            {
                                photosLink.append(photo["photo_reference"] as! String)
                            }
                        }
                    }
                }
                
                arrayPlace.append(Place(idPlace: idPlace, name: name, typePlace: typePlace, typeFood: nil, typeDrink: nil, rating: rating?.description, priceLevel: priceLevel?.description, menu: nil, website: website, phoneNumber: phoneNumber, openingHours: openingHours, address: address, city: city, state: state, zipCode: zipCode, country: country, photosLink: photosLink, icon: icon, openNow: openNow ?? false, formattedAddress: formattedAddress))
 
                // var typeFood: String?
                // var typeDrink : String?
                // var menu : String?
                completion(arrayPlace)
            }
        }
    }
}
