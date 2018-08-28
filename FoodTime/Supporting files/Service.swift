//
//  Service.swift
//  FoodTime
//
//  Created by floriane sanchis on 16/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit
import JGProgressHUD

class Service {
    
    //API KEY
    static let GooglePlaceAPIKeyIOS : String = "AIzaSyA8vcbGXF3gDkIe1zzw7k0fSCDEKZ6CbuU"
    static let GooglePlaceAPIKeyWS : String = "AIzaSyAsdGZ-BbG1W6KmU9LhbloVh1bzjpMwdsQ"
    
    static let AraGooglePlaceAPIKeyWS : String = "AIzaSyChd5nTkODfGoB8L05JS-lpuvyXBhiwNCQ"
    static let AraGooglePlaceAPIKeyIOS : String = "AIzaSyBieS_Wm8SSu8kVVcSRjKnoK2S4dkHcJ3A "
    static let AraGooglePlaceAPIKey : String = "AIzaSyD62iGuyY7dIWTpgPVVdwhNX759awmB9Xo"
    
    //Button properties
    static let buttonTitleFontSize: CGFloat = 16
    static let buttonTitleColor: UIColor = UIColor.white
    static let buttonCornerRadius: CGFloat = 7
    static let buttonBackgroundColorSignInWithFacebook = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
    
    //Formatter
    static let formatterDate : String = "yyyy-MM-dd HH:mm:ss Z"
    
    //Image
    static let BookmarkEmptyIcon : String = "bookmark-icon"
    static let BookmarkFullEmptyIcon : String = "bookmarkfull-icon"
    static let CrossIcon : String = "cross-icon"
    static let CityPlaceIcon : String = "cityPlace-icon"
    static let FoodPlaceIcon : String = "foodPlace-icon"
    static let LikeEmptyIcon : String = "like-icon"
    static let LikeFullIcon : String = "likefull-icon"
    static let PriceLevelOne : String = "priceLevelOne-icon"
    static let PriceLevelTwo : String = "priceLevelTwo-icon"
    static let PriceLevelThree : String = "priceLevelThree-icon"
    
    //Name of the Storyboards
    static let MainStoryboard : String = "Main"
        
    //Language app
    static let LanguageApp : String = Locale.current.languageCode!
    
    //Name of the ViewControllers
    static let CreateTripViewController : String = "CreateTripViewController"
    static let ChoicePlaceViewController : String = "ChoicePlaceViewController"
    static let ChoiceTypeFoodViewController : String = "ChoiceTypeFoodViewController"
    static let ChoiceTypeDrinkViewController : String = "ChoiceTypeDrinkViewController"
    static let ChoiceNotificationViewController : String = "ChoiceNotificationViewController"
    static let ChoiceUserPageViewController : String = "ChoiceUserPageViewController"
    static let GetStartedViewController : String = "GetStartedViewController"
    static let HomeViewController : String = "HomeViewController"
    static let LoginViewController : String = "LoginViewController"
    static let ManageTripViewController : String = "ManageTripViewController"
    static let ManageTripEmptyViewController : String = "ManageTripEmptyViewController"
    static let ModifyTripViewController : String = "ModifyTripViewController"
    static let MyEmptyTripsViewController : String = "MyEmptyTripsViewController"
    static let MyListTripsViewController : String = "MyListTripsViewController"
    static let PlaceViewController : String = "PlaceViewController"
    static let SearchPlaceDetailViewController : String = "SearchPlaceDetailViewController"
    static let SearchPlaceMapViewController : String = "SearchPlaceMapViewController"
    static let SearchPlaceViewController : String = "SearchPlaceViewController"
    
    //TableViewCell
    static let ChoiceTypeFoodTableViewCell : String = "ChoiceTypeFoodTableViewCell"
    static let ChoiceTypeDrinkTableViewCell : String = "ChoiceTypeDrinkTableViewCell"
    static let SearchPlaceTableViewCell : String = "SearchPlaceTableViewCell"
    static let SearchPlaceDetailTableViewCell : String = "SearchPlaceDetailTableViewCell"
    static let ManageTripTableViewCell : String = "ManageTripTableViewCell"
    
    //Notification by ViewController
    //LoginViewController
    static let sendGoogleDataToLoginViewController : NSNotification.Name = Notification.Name("sendGoogleDataToLoginViewController")
    //ChoiceUser
    static let Scroll : NSNotification.Name = Notification.Name("scroll")
    
    //Identifier
    //table view cell for ChoiceTypeFoodViewController
    static let ChoiceTypeFoodIdCell : String = "typeFoodCell"
    //table view cell for ChoiceTypeDrinkViewController
    static let ChoiceTypeDrinkIdCell : String = "typeDrinkCell"
    //table view cell for SearchPlaceViewController
    static let SearchPlaceIdCell : String = "searchPlaceCell"
    //table view cell for SearchPlaceViewController
    static let SearchPlaceDetailIdCell : String = "searchPlaceDetailCell"
    //table view cell for MyListTripsViewController
    static let MyListTripsIdCell : String = "myListTripsCell"
    //table viez cell for ManageTripViewController
    static let ManageTripIdCell : String = "manageTripCell"
    
    
    static func showAlert(on: UIViewController, style: UIAlertControllerStyle, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion)
    }
    
    static func dismissHud(_ hud: JGProgressHUD, text: String, detailText: String, delay: TimeInterval) {
        hud.textLabel.text = text
        hud.detailTextLabel.text = detailText
        hud.dismiss(afterDelay: delay, animated: true)
    }
    
    static func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
