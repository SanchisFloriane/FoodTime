//
//  String.swift
//  FoodTime
//
//  Created by bob on 8/6/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation

extension String {
   
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
