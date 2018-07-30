//
//  TypePlace.swift
//  FoodTime
//
//  Created by bob on 7/26/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit
import Firebase

enum TypePlace: Int, CaseIterable
{
    case typeDrinkPlace = 0
    case typeFoodPlace = 1
    
    enum AllPlace: Int, CaseIterable
    {
        case Bar = 0
        case Coffee = 1
        case FastFood = 2
        case FoodTruck = 3
        case Restaurant = 4
    }
    
    enum TypePlaceFood: Int, CaseIterable
    {
        case FastFood = 2
        case FoodTruck = 3
        case Restaurant = 4
    }
    
    enum TypePlaceDrink: Int, CaseIterable
    {
        case Bar = 0
        case Coffee = 1
    }
    
    static func toEnum(idEnum: Int) -> TypePlace.AllPlace?
    {
        switch idEnum {
            case 0:
                return .Bar
            case 1:
                return .Coffee
            case 2:
                return .FastFood
            case 3:
                return .FoodTruck
            case 4:
                return .Restaurant
            default:
                return nil
        }
    }
    
    static func getTypePlace(typePlace: Int) -> TypePlace?
    {
        for typeFoodPlace in TypePlace.TypePlaceFood.allCases
        {
            if typeFoodPlace.rawValue == typePlace
            {
                return TypePlace.typeFoodPlace
            }
        }
        
        for typeDrinkPlace in TypePlace.TypePlaceDrink.allCases
        {
            if typeDrinkPlace.rawValue == typePlace
            {
                return TypePlace.typeDrinkPlace
            }
        }
        
        return nil
    }
    
    static func getPlacesByType(typlePlace: TypePlace, tab: [TypePlace.AllPlace]) -> [TypePlace.AllPlace?]
    {
        var returnTab : [TypePlace.AllPlace?] = [TypePlace.AllPlace?]()
        for place in tab
        {
            if getTypePlace(typePlace: place.rawValue) == typlePlace
            {
                returnTab.append(place)
            }
        }
        
        return returnTab
    }
    
    static func toString(typePlace: TypePlace.AllPlace, completion: @escaping (String) -> ())
    {
        var value : String = ""
        Database.database().reference().child("\(ModelDB.typePlace)/\(Service.LanguageApp)/\(typePlace.rawValue.description)").observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                let listChildren = snapchot.children
                while let child = listChildren.nextObject() as? DataSnapshot
                {
                    value = child.value as! String
                    completion(value)
                }
            }
        })
    }
}
