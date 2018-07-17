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
    
    let TermsPrivatePolicyButton : String = "TermsPrivatePolicyButton"
    
    let EmailConnectionButton : String = "EmailConnectionButton"
    
    let GetStartedButton : String = "GetStartedButton"
    
    let TaglineTextMainPage : String = "TaglineTextMainPage"
    
    let LogginButton : String = "LogginButton"
    
    let FBConnectionButton : String = "FBConnectionButton"
    
}
