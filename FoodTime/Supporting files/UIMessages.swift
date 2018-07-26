//
//  UIMessages.swift
//  FoodTime
//
//  Created by floriane sanchis on 23/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation

class UIMessages {
    
    init() {
        
    }
    
    func localize(key: String, comment: String) -> String
    {
        return NSLocalizedString(key, comment: comment)
    }
    
    func localizeWithoutComment(key: String) -> String
    {
        return NSLocalizedString(key, comment: "")
    }
    
    let ErrorTitle : String = "ErrorTitle"
    
    let ErrorEmail : String = "ErrorEmail"
    
    let ErrorEmailExists : String = "ErrorEmailExists"
    
    let ErrorFormatPassword : String = "ErrorFormatPassword"
    
    let ErrorPassword : String = "ErrorPassword"
        
    let UserNotFound : String = "UserNotFound"

}
