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
    
    let ActivateNotificationsButton : String = "ActivateNotificationsButton"
    
    let CreateUserAccount : String = "CreateUserAccount"
    
    let DescriptionPageChoiceNotificationViewController : String = "DescriptionPageChoiceNotificationViewController"
    
    let DescriptionPageChoiceTypeFoodViewController : String = "DescriptionPageChoiceTypeFoodViewController"
    
    let DescriptionPageChoiceTypeDrinkViewController : String = "DescriptionPageChoiceTypeDrinkViewController"
    
    let DescriptionPageChoiceTypePlaceViewController : String = "DescriptionPageChoiceTypePlaceViewController"
    
    let Email: String = "Email"
    
    let EmailSignInButton : String = "EmailSignInButton"
    
    let EmailSignUpButton : String = "EmailSignUpButton"
    
    let EmailTitle : String = "EmailTitle"
    
    let FBSignInButton : String = "FBSignInButton"
    
    let FBSignUpButton : String = "FBSignUpButton"
    
    let GoogleSignInButton : String = "GoogleSignInButton"
    
    let GoogleSignUpButton : String = "GoogleSignUpButton"
    
    let GetStartedButton : String = "GetStartedButton"
    
    let LogginButton : String = "LogginButton"
    
    let Password : String = "Password"
    
    let PasswordConfirmation : String = "PasswordConfirmation"
    
    let SkipButton : String = "SkipButton"
    
    let TaglineTextMainPage : String = "TaglineTextMainPage"
    
    let TermsPrivatePolicyButton : String = "TermsPrivatePolicyButton"
    
    let TitlePageChoiceNotificationViewController : String = "TitlePageChoiceNotificationViewController"
    
    let TitlePageChoiceTypeFoodViewController : String = "TitlePageChoiceTypeFoodViewController"
    
    let TitlePageChoiceTypeDrinkViewController : String = "TitlePageChoiceTypeDrinkViewController"
    
    let TitlePageChoiceTypePlaceViewController : String = "TitlePageChoiceTypePlaceViewController"
    
    let ValidateButton : String = "ValidateButton"
}
