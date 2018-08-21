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
    var openNow: Bool?
    var formattedAddress: String?
    var latLocation : Double?
    var lngLocation : Double?
    var latNortheast : Double?
    var lngNortheast : Double?
    var latSouthwest : Double?
    var lngSouthwest : Double?
    
    init() {}
    
    init(idPlace: String!)
    {
        self.idPlace = idPlace
    }
    
    init(idPlace: String?, name: String?, typePlace: [String?], typeFood: String?, typeDrink: String?, rating: String?, priceLevel: String?, menu: String?, website: String?, phoneNumber: String?, openingHours: [String?], address: String?, city: String?, state: String?, zipCode: String?, country: String?, photosLink: [String?], icon: String?, openNow: Bool, formattedAddress: String?, latLocation: Double?, lngLocation: Double?, latNortheast: Double?, lngNortheast: Double?, latSouthwest: Double?, lngSouthwest: Double?) {
        
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
        self.openNow = openNow
        self.formattedAddress = formattedAddress
        self.latLocation = latLocation
        self.lngLocation = lngLocation
        self.latNortheast = latNortheast
        self.lngNortheast = lngNortheast
        self.latSouthwest = latSouthwest
        self.lngSouthwest = lngSouthwest
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
    
    static func jsonToPlace(tab: [String : Any]?, requestPhoto: Bool, completion:@escaping (Place)->() )
    {
        var placeConverted : Place?
        
        // Parse the json results into an array of Place objects
        
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
        var address : String?
        var city : String?
        var state : String?
        var zipCode : String?
        var country : String?
        var route : String?
        var streetNumber : String?
        var typePlace : [String?] = [String?]()
        var photosLink : [String] = [String]()
        var latLocation : Double?
        var lngLocation : Double?
        var latNortheast : Double?
        var lngNortheast : Double?
        var latSouthwest : Double?
        var lngSouthwest : Double?
        
        
        if let places = tab?["result"] as? [String : Any]
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
                
                if place.key == "geometry"
                {
                    let geometryJSON = place.value as? [String: [String: Any]]
                    
                    for field in geometryJSON!
                    {
                        if field.key == "location"
                        {
                            for fieldLocation in field.value
                            {
                                if fieldLocation.key == "lat"
                                {
                                    latLocation = fieldLocation.value as? Double
                                }
                                
                                if fieldLocation.key == "lng"
                                {
                                    lngLocation = fieldLocation.value as? Double
                                }
                            }
                        }
                        
                        if field.key == "viewport"
                        {
                            let viewport = field.value as? [String: [String: Any]]
                            for fieldViewport in viewport!
                            {
                                if fieldViewport.key == "northeast"
                                {
                                   for fieldNortheast in fieldViewport.value
                                   {
                                        if fieldNortheast.key == "lat"
                                        {
                                            latNortheast = fieldNortheast.value as? Double
                                        }
                                    
                                        if fieldNortheast.key == "lng"
                                        {
                                            lngNortheast = fieldNortheast.value as? Double
                                        }
                                    }
                                }
                                
                                if fieldViewport.key == "southwest"
                                {
                                    for fieldSouthwest in fieldViewport.value
                                    {
                                        if fieldSouthwest.key == "lat"
                                        {
                                            latSouthwest = fieldSouthwest.value as? Double
                                        }
                                        
                                        if fieldSouthwest.key == "lng"
                                        {
                                            lngSouthwest = fieldSouthwest.value as? Double
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // var typeFood: String?
                // var typeDrink : String?
                // var menu : String?
            }
            
            placeConverted = Place(idPlace: idPlace, name: name, typePlace: typePlace, typeFood: nil, typeDrink: nil, rating: rating?.description, priceLevel: priceLevel?.description, menu: nil, website: website, phoneNumber: phoneNumber, openingHours: openingHours, address: address, city: city, state: state, zipCode: zipCode, country: country, photosLink: photosLink, icon: icon, openNow: openNow ?? false, formattedAddress: formattedAddress, latLocation: latLocation, lngLocation: lngLocation, latNortheast: latNortheast, lngNortheast: lngNortheast, latSouthwest: latSouthwest, lngSouthwest: lngSouthwest)
            
            completion(placeConverted!)
        }
    }
    
    static func jsonToPlaces(tab: [String : Any]?, requestPhoto: Bool, completion:@escaping ([Place])->() )
    {
        var arrayPlace : [Place] = [Place]()
        
        // Parse the json results into an array of Place objects
        
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
        var typePlace : [String?] = [String?]()
        var address : String?
        var city : String?
        var state : String?
        var zipCode : String?
        var country : String?
        var route : String?
        var streetNumber : String?
        var photosLink : [String] = [String]()
        var latLocation : Double?
        var lngLocation : Double?
        var latNortheast : Double?
        var lngNortheast : Double?
        var latSouthwest : Double?
        var lngSouthwest : Double?
        
        if let places = tab?["results"] as? [[String : Any]]
        {
            for place in places
            {
                if let idPlaceValue = place["place_id"] as? String
                {
                    idPlace = idPlaceValue
                }
                
                if let nameValue = place["name"] as? String
                {
                    name = nameValue
                }
                
                if let formattedAddressValue = place["formatted_address"] as? String
                {
                    formattedAddress = formattedAddressValue
                }
                
                if let ratingValue = place["rating"] as? Double
                {
                    rating = ratingValue
                }
                
                if let priceLevelValue = place["price_level"] as? Int
                {
                    priceLevel = priceLevelValue
                }
                
                if let websiteValue = place["website"] as? String
                {
                    website = websiteValue
                }
                
                if let phoneNumberValue = place["international_phone_number"] as? String
                {
                    phoneNumber = phoneNumberValue
                }
                
                if let iconValue = place["icon"] as? String
                {
                    icon = iconValue
                }
                
                if let openingHoursValue = place["opening_hours"] as? [String : Any]
                {
                    let openingHoursJSON = openingHoursValue
                    if let opennow = openingHoursJSON["open_now"] as? Bool
                    {
                        openNow = opennow
                    }
                    
                    if let weekdayText = openingHoursJSON["weekday_text"] as? [String]
                    {
                        for day in weekdayText
                        {
                            openingHours.append(day)
                        }
                    }
                }
                
                if let addressComponentValue = place["address_components"] as? [[String: Any]]
                {
                    let addressComponent = addressComponentValue
                    
                    for field in addressComponent
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
                
                if let typePlaceValue = place["types"] as? [String]
                {
                    let typePlaceJSON = typePlaceValue
                    
                    if !(typePlaceJSON.isEmpty)
                    {
                        for placeJSON in typePlaceJSON
                        {
                            if TypePlace.TypePlaceJSON.findPlaceJSON(typePlaceJSON: placeJSON) != nil
                            {
                                typePlace.append(placeJSON)
                            }
                        }
                    }
                }
                
                if requestPhoto
                {
                    if let photosValue = place["photos"] as? [[String : Any]]
                    {
                        let photos = photosValue
                        
                        if !(photos.isEmpty)
                        {
                            for photo in photos
                            {
                                photosLink.append(photo["photo_reference"] as! String)
                            }
                        }
                    }
                }
                
                if let geometryJSON = place["geometry"] as? [[String: Any]]
                {
                    for field in geometryJSON
                    {
                        if let location = field["location"] as? [[String: Any]]
                        {
                            for fieldLocation in location
                            {
                                if let latLocationValue = fieldLocation["lat"] as? Double
                                {
                                    latLocation = latLocationValue
                                }
                                
                                if let lngLocationValue = fieldLocation["lng"] as? Double
                                {
                                    lngLocation = lngLocationValue
                                }
                            }
                        }
                        
                        if let viewport = field["viewport"] as? [[String: Any]]
                        {
                            for fieldViewport in viewport
                            {
                                if let northeast = fieldViewport["northeast"] as? [String: Any]
                                {
                                    if let latNortheastValue = northeast["lat"] as? Double
                                    {
                                        latNortheast = latNortheastValue
                                    }
                                    
                                    if let lngNortheastValue = northeast["lng"] as? Double
                                    {
                                        lngNortheast = lngNortheastValue
                                    }
                                }
                                
                                if let southwest = fieldViewport["southwest"] as? [String: Any]
                                {
                                    if let latSouthwestValue = southwest["lat"] as? Double
                                    {
                                        latSouthwest = latSouthwestValue
                                    }
                                    
                                    if let lngSouthwestValue = southwest["lng"] as? Double
                                    {
                                        lngSouthwest = lngSouthwestValue
                                    }
                                }
                            }
                        }
                    }
                }
                
                arrayPlace.append(Place(idPlace: idPlace, name: name, typePlace: typePlace, typeFood: nil, typeDrink: nil, rating: rating?.description, priceLevel: priceLevel?.description, menu: nil, website: website, phoneNumber: phoneNumber, openingHours: openingHours, address: address, city: city, state: state, zipCode: zipCode, country: country, photosLink: photosLink, icon: icon, openNow: openNow ?? false, formattedAddress: formattedAddress,  latLocation: latLocation, lngLocation: lngLocation, latNortheast: latNortheast, lngNortheast: lngNortheast, latSouthwest: latSouthwest, lngSouthwest: lngSouthwest))
            }
            
            // var typeFood: String?
            // var typeDrink : String?
            // var menu : String?
            completion(arrayPlace)
        }
    }
}
