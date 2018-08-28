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
    
    static let AddTrip : String = "AddTrip"
    
    static let ActivateNotificationsButton : String = "ActivateNotificationsButton"
    
    static let Cancel : String = "Cancel"
    
    static let CreateUserAccount : String = "CreateUserAccount"
    
    static let CreateATrip : String = "CreateATrip"
    
    static let Delete : String = "Delete"
    
    static let DescriptionPageChoiceNotificationViewController : String = "DescriptionPageChoiceNotificationViewController"
    
    static let DescriptionPageChoiceTypeFoodViewController : String = "DescriptionPageChoiceTypeFoodViewController"
    
    static let DescriptionPageChoiceTypeDrinkViewController : String = "DescriptionPageChoiceTypeDrinkViewController"
    
    static let DescriptionPageChoiceTypePlaceViewController : String = "DescriptionPageChoiceTypePlaceViewController"

    static let DescriptionMyEmptyTripsViewController : String = "DescriptionMyEmptyTripsViewController"
    
    static let DescriptionPageManageTripEmptyViewController : String = "DescriptionPageManageTripEmptyViewController"
    
    static let Details : String = "Details"
    
    static let Email: String = "Email"
    
    static let EmailSignInButton : String = "EmailSignInButton"
    
    static let EmailSignUpButton : String = "EmailSignUpButton"
    
    static let EmailTitle : String = "EmailTitle"
    
    static let EnterAName : String = "EnterAName"
    
    static let EndDate : String = "EndDate"
    
    static let FBSignInButton : String = "FBSignInButton"
    
    static let FBSignUpButton : String = "FBSignUpButton"
    
    static let GoogleSignInButton : String = "GoogleSignInButton"
    
    static let GoogleSignUpButton : String = "GoogleSignUpButton"
    
    static let GetStartedButton : String = "GetStartedButton"
    
    static let Km : String = "Km"
    
    static let LogginButton : String = "LogginButton"
    
    static let Miles : String = "Miles"
    
    static let ManageMyTrip : String = "ManageMyTrip"
    
    static let Map : String = "Map"
    
    static let ModifyTrip : String = "ModifyTrip"
    
    static let MyNewsButton : String = "MyNewsButton"
    
    static let MyPlacesButton : String = "MyPlacesButton"
    
    static let MyProfileButton : String = "MyProfileButton"
    
    static let MyTrips : String = "MyTrips"
    
    static let NameTrip : String = "NameTrip"
    
    static let NewsTitle : String = "NewsTitle"
    
    static let NoPhoneNumber : String = "NoPhoneNumber"
    
    static let NoWebsite : String = "NoWebsite"
    
    static let Password : String = "Password"
    
    static let PlaceInformationTitle : String = "PlaceInformationTitle"
    
    static let PlaceClosedNow : String = "PlaceClosedNow"
    
    static let PlaceOpenNow : String = "PlaceOpenNow"
    
    static let PasswordConfirmation : String = "PasswordConfirmation"
    
    static let Recent : String = "Recent"
    
    static let RecentlyViewedBtn : String = "RecentlyViewedBtn"
    
    static let RecommandationsButton : String = "RecommandationsButton"
    
    static let Reviews : String = "Reviews"
    
    static let Save : String = "Save"
    
    static let SearchLocationBarPlaceHolder : String = "SearchLocationBarPlaceHolder"
    
    static let SearchPlaceBarPlaceHolder : String = "SearchPlaceBarPlaceHolder"
    
    static let SkipButton : String = "SkipButton"
    
    static let SortedBy : String = "SortedBy"
    
    static let SortByAlert : String = "SortByAlert"
    
    static let StartDate : String = "StartDate"
    
    static let TaglineTextMainPage : String = "TaglineTextMainPage"
    
    static let TermsPrivatePolicyButton : String = "TermsPrivatePolicyButton"
    
    static let TitlePageChoiceNotificationViewController : String = "TitlePageChoiceNotificationViewController"
    
    static let TitlePageChoiceTypeFoodViewController : String = "TitlePageChoiceTypeFoodViewController"
    
    static let TitlePageChoiceTypeDrinkViewController : String = "TitlePageChoiceTypeDrinkViewController"
    
    static let TitlePageChoiceTypePlaceViewController : String = "TitlePageChoiceTypePlaceViewController"
    
    static let TitleSearchPlaceDetailViewController : String = "TitleSearchPlaceDetailViewController"
    
    static let TitleMyEmptyTripsViewController : String = "TitleMyEmptyTripsViewController"
    
    static let TripsBtn : String = "TripsBtn"
    
    static let ValidateButton : String = "ValidateButton"
    
    static let VisitWebsiteLink : String = "VisitWebsiteLink"
    
    static let Update : String = "Update"

}
