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
    
    //Button properties
    static let buttonTitleFontSize: CGFloat = 16
    static let buttonTitleColor: UIColor = UIColor.white
    static let buttonCornerRadius: CGFloat = 7
    static let buttonBackgroundColorSignInWithFacebook = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
    
    //Name of the Storyboards
    static let MainStoryboard : String = "Main"
        
    //Language app
    static let LanguageApp : String = Locale.current.languageCode!
    
    //Name of the ViewControllers
    static let GetStartedViewController : String = "GetStartedViewController"
    static let LoginViewController : String = "LoginViewController"
    static let ChoicePlaceViewController : String = "ChoicePlaceViewController"
    static let HomeViewController : String = "HomeViewController"
    static let ChoiceTypeFoodViewController : String = "ChoiceTypeFoodViewController"
    static let ChoiceTypeDrinkViewController : String = "ChoiceTypeDrinkViewController"
    static let ChoiceUserPageViewController : String = "ChoiceUserPageViewController"
    
    //TableViewCell
    static let ChoiceTypeFoodViewCell : String = "ChoiceTypeFoodViewCell"
    static let ChoiceTypeDrinkViewCell : String = "ChoiceTypeDrinkViewCell"
    
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
}
