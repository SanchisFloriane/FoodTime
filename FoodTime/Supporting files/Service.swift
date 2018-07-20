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
    
    static let buttonTitleFontSize: CGFloat = 16
    static let buttonTitleColor: UIColor = UIColor.white
    static let buttonCornerRadius: CGFloat = 7
    static let buttonBackgroundColorSignInWithFacebook = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
    
    //Name of the Storyboards
    static let MainStoryboard : String = "Main"
    
    //Name of the ViewControllers
    static let GetStartedViewController : String = "GetStartedViewController"
    static let LoginViewController : String = "LoginViewController"
    static let ChoicePlaceViewController : String = "ChoicePlaceViewController"
    static let HomeViewController : String = "HomeViewController"
    
    //Notification by ViewController
    static let sendGoogleDataToLoginViewController : NSNotification.Name = Notification.Name("sendGoogleDataToLoginViewController")
    
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
