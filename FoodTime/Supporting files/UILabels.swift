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
    
    static func localize(key: String, comment: String) -> String
    {
        return NSLocalizedString(key, comment: comment)
    }
    
    static func localizeWithoutComment(key: String) -> String
    {
        return NSLocalizedString(key, comment: "")
    }
    
    static let ActivateNotificationsButton : String = "ActivateNotificationsButton"
    
    static let CreateUserAccount : String = "CreateUserAccount"
    
    static let DescriptionPageChoiceNotificationViewController : String = "DescriptionPageChoiceNotificationViewController"
    
    static let DescriptionPageChoiceTypeFoodViewController : String = "DescriptionPageChoiceTypeFoodViewController"
    
    static let DescriptionPageChoiceTypeDrinkViewController : String = "DescriptionPageChoiceTypeDrinkViewController"
    
    static let DescriptionPageChoiceTypePlaceViewController : String = "DescriptionPageChoiceTypePlaceViewController"
    
    static let Email: String = "Email"
    
    static let EmailSignInButton : String = "EmailSignInButton"
    
    static let EmailSignUpButton : String = "EmailSignUpButton"
    
    static let EmailTitle : String = "EmailTitle"
    
    static let FBSignInButton : String = "FBSignInButton"
    
    static let FBSignUpButton : String = "FBSignUpButton"
    
    static let GoogleSignInButton : String = "GoogleSignInButton"
    
    static let GoogleSignUpButton : String = "GoogleSignUpButton"
    
    static let GetStartedButton : String = "GetStartedButton"
    
    static let Km : String = "Km"
    
    static let LogginButton : String = "LogginButton"
    
    static let NewsTitle : String = "NewsTitle"
    
    static let Miles : String = "Miles"
    
    static let MyNewsButton : String = "MyNewsButton"
    
    static let MyPlacesButton : String = "MyPlacesButton"
    
    static let MyProfileButton : String = "MyProfileButton"
    
    static let Password : String = "Password"
    
    static let PasswordConfirmation : String = "PasswordConfirmation"
    
    static let RecommandationsButton : String = "RecommandationsButton"
    
    static let SearchLocationBarPlaceHolder : String = "SearchLocationBarPlaceHolder"
    
    static let SearchPlaceBarPlaceHolder : String = "SearchPlaceBarPlaceHolder"
    
    static let SkipButton : String = "SkipButton"
    
    static let TaglineTextMainPage : String = "TaglineTextMainPage"
    
    static let TermsPrivatePolicyButton : String = "TermsPrivatePolicyButton"
    
    static let TitlePageChoiceNotificationViewController : String = "TitlePageChoiceNotificationViewController"
    
    static let TitlePageChoiceTypeFoodViewController : String = "TitlePageChoiceTypeFoodViewController"
    
    static let TitlePageChoiceTypeDrinkViewController : String = "TitlePageChoiceTypeDrinkViewController"
    
    static let TitlePageChoiceTypePlaceViewController : String = "TitlePageChoiceTypePlaceViewController"
    
    static let TitleSearchPlaceDetailViewController : String = "TitleSearchPlaceDetailViewController"
    
    static let ValidateButton : String = "ValidateButton"
}
