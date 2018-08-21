//
//  GoogleServices.swift
//  FoodTime
//
//  Created by bob on 8/8/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

class GoogleServices
{
    static func performGoogleQuery(url: URL,completion:@escaping ([String : Any]?)->())
    {
        var json : [String : Any]?
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            
            if error != nil
            {
                print("An error occured: \(String(describing: error))")
                completion(nil)
            }
            
            do
            {
                json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                completion(json)
            }
            catch
            {
                print("error serializing JSON: \(error)")
                completion(nil)
            }
        })
        task.resume()
    }
    
    static func loadPlace(idPlace: String!, completion:@escaping (Place)->())
    {
        let idPlace : String = "&placeid=\(idPlace!)"
        let APIKey : String = "&key=\(Service.AraGooglePlaceAPIKey)"
        let language : String = "&language=\(Locale.current.languageCode!)"
        var url = "https://maps.googleapis.com/maps/api/place/details/json?"
        let query = ("\(idPlace)\(APIKey)\(language)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        url.append("\(query!)")
        GoogleServices.performGoogleQuery(url: URL(string: url)!, completion: { (json) in
            Place.jsonToPlace(tab: json, requestPhoto: true, completion: { (placeConverted) in
                completion(placeConverted)
            })
        })
    }
    
    
    // If there is another page of results,
    // configure the new url and run the query again.
    /*if let pageToken = json?["next_page_token"]
     {
     let newURL : URL = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?pagetoken=\(pageToken)&key=\(Service.AraGooglePlaceAPIKey)")!
     self.performGoogleQuery(url: newURL)
     }*/
    
    
    
}
