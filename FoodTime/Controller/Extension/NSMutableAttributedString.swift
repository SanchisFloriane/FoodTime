//
//  NSMutableAttributedString.swift
//  FoodTime
//
//  Created by floriane sanchis on 17/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
