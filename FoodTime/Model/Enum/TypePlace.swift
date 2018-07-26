//
//  TypePlace.swift
//  FoodTime
//
//  Created by bob on 7/26/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation

enum TypePlace: Int
{
    case Bar = 0
    case Coffee = 1
    case FastFood = 2
    case FoodTruck = 3
    case Restaurant = 4
    
    static func toEnum(idEnum: Int) -> TypePlace?
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
}
