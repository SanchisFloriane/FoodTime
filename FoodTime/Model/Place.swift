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
    
    static func jsonToPlace(tab: [String : Any]?, requestPhoto: Bool) -> [Place]
    {
        var arrayPlace : [Place] = [Place]()
        
        // Parse the json results into an array of Place objects
        if let places = tab?["results"] as? [[String : Any]]
        {
            for place in places
            {
                let idPlace = place["place_id"] as? String
                let name = place["name"] as? String
                let formattedAddress = place["formatted_address"] as? String
                let rating = place["rating"] as? Double
                let priceLevel = place["price_level"] as? Int
                let website = place["website"] as? String
                let phoneNumber = place["international_phone_number"] as? String
                let openNow = place["openNow"] as? Bool
                let icon = place["icon"] as? String
                if let openingHours = place["opening_hours"] as? [String : Any]
                {
                    if let periods = openingHours["opening_hours"] as? [String : Any]
                    {
                        if let open = periods["open"] as? [String : Any]
                        {
                            if let day = open["day"] as? [String : Any]
                            {
                                print("\(day)")
                            }
                            
                            if let time = open["time"] as? [String : Any]
                            {
                                print("\(time)")
                            }
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
                
                if let addressComponent = place["address_component"] as? [String: Any]
                {
                    for field in addressComponent
                    {
                        print(field)
                        print(field.key)
                        print(field.value)
                        if field.key == "types"
                        {
                            let typeField = field.key
                            if typeField == "street_number"
                            {
                                streetNumber = field.value as? String
                            }
                            else if typeField == "route"
                            {
                                route = field.value as? String
                            }
                            else if typeField == "locality"
                            {
                                city = field.value as? String
                            }
                            else if typeField == "administrative_area_level_1"
                            {
                                state = field.value as? String
                            }
                            else if typeField == "country"
                            {
                                country = field.value as? String
                            }
                            else if typeField == "postal_code"
                            {
                                zipCode = field.value as? String
                            }
                        }
                    }
                    
                    address = "\(String(describing: streetNumber)) \(String(describing: route))"
                }
                
                let typePlaceJSON = place["types"] as? [String]
                var typePlace : [String?] = [String?]()
                
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
                
                if requestPhoto
                {
                    let photos = place["photos"] as? [[String : Any]]
                    
                    if photos != nil && !(photos?.isEmpty)!
                    {
                        for photo in photos!
                        {
                            //request photo
                            //https://maps.googleapis.com/maps/api/place/photo?parameters
                            //photo?.photo_reference
                        }
                    }
                }
                
                arrayPlace.append(Place(idPlace: idPlace, name: name, typePlace: typePlace, typeFood: nil, typeDrink: nil, rating: rating?.description, priceLevel: priceLevel?.description, menu: nil, website: website, phoneNumber: phoneNumber, openingHours: nil, address: address, city: city, state: state, zipCode: zipCode, country: country, photosLink: [String?](), icon: icon, openNow: openNow ?? false, formattedAddress: formattedAddress))
 
                // var typeFood: String?
                // var typeDrink : String?
                // var menu : String?
            }
        }
        
        return arrayPlace
    }
    
}
