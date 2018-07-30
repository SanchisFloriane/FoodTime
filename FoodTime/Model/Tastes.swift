//
//  Tastes.swift
//  FoodTime
//
//  Created by bob on 7/30/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit

class Tastes {
    
    //Attributes in DB
    var typeDrinkPlace: [String?] = [String?]()
    var typeFoodPlace: [String?] = [String?]()
    var typeDrink: [String?] = [String?]()
    var typeFood: [String?] = [String?]()
    
    init() {}
    
    init(typeDrinkPlace: [String?],typeFoodPlace: [String?],typeDrink: [String?],typeFood: [String?]) {
        
        self.typeDrinkPlace = typeDrinkPlace
        self.typeFoodPlace = typeFoodPlace
        self.typeDrink = typeDrink
        self.typeFood = typeFood
    }
    
    func getData() -> [String: [String?]]
    {
        return [ModelDB.Tastes_typeDrinkPlace: self.typeDrinkPlace,
                ModelDB.Tastes_typeFoodPlace: self.typeFoodPlace,
                ModelDB.Tastes_typeDrink : self.typeDrink,
                ModelDB.Tastes_typeFood : self.typeFood]
    }
}
