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
    
    static func localize(key: String, comment: String) -> String
    {
        return NSLocalizedString(key, comment: comment)
    }
    
    static func localizeWithoutComment(key: String) -> String
    {
        return NSLocalizedString(key, comment: "")
    }
    
    static let ErrorTitle : String = "ErrorTitle"
    
    static let ErrorEmail : String = "ErrorEmail"
    
    static let ErrorEmailExists : String = "ErrorEmailExists"
    
    static let ErrorEnterLocation : String = "ErrorEnterLocation"
    
    static let ErrorEnterPlace : String = "ErrorEnterPlace"
    
    static let ErrorFormatPassword : String = "ErrorFormatPassword"
    
    static let ErrorPassword : String = "ErrorPassword"
        
    static let UserNotFound : String = "UserNotFound"
    
    

}
