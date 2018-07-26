//
//  TypeFood.swift
//  FoodTime
//
//  Created by bob on 7/26/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation

enum TypeFood: Int
{
    case French = 0
    case Italian = 1
    case American = 2
    
    static func toEnum(idEnum: Int) -> TypeFood?
    {
        switch idEnum {
        case 0:
            return .French
        case 1:
            return .Italian
        case 2:
            return .American
        default:
            return nil
        }
    }
}
