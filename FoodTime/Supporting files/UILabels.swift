//
//  UILabels.swift
//  FoodTime
//
//  Created by bob on 7/17/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation

class UILabels {
    
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
    
    let Email: String = "Email"
    
    let EmailConnectionButton : String = "EmailConnectionButton"
    
    let EmailTitle : String = "EmailTitle"
    
    let FBConnectionButton : String = "FBConnectionButton"
    
    let GetStartedButton : String = "GetStartedButton"
    
    let LogginButton : String = "LogginButton"
    
    let Password : String = "Password"
    
    let TaglineTextMainPage : String = "TaglineTextMainPage"
    
    let TermsPrivatePolicyButton : String = "TermsPrivatePolicyButton"
    
    
}
