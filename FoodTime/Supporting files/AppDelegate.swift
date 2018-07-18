//
//  AppDelegate.swift
//  FoodTime
//
//  Created by Sanchis Floriane on 7/10/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FBSDKLoginButtonDelegate ,GIDSignInDelegate {
    
    var window: UIWindow?
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil
        {
            Service.dismissHud(self.hud, text: "Error connection FB", detailText: "Failed to log in in to FB.", delay: 3)
            return
        }
        
        print("Succesfully authenticated with FB.")
        let credentials = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credentials, completion: { (authResult, error) in
            
            if let error = error {
                
                Service.dismissHud(self.hud, text: "Sign up error FB with Firebase", detailText: error.localizedDescription, delay: 3)
                return
            }
            print("Succesfully authenticated with FB Firebase. \(String(describing: authResult))")
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, first_name, last_name, picture.type(large)"]).start{ (connection, result, error) in
                if error != nil {
                    Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user. \(String(describing: error))", delay: 3)
                    return
                }
                
                let fullName = authResult?.user.displayName
                print("\(String(describing: fullName))")
                print("\(String(describing: result))")
            }
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
       
        let firebaseAuth = Auth.auth()
        do
        {
            try firebaseAuth.signOut()
            print("Log out of FB")
        }
        catch let signOutError as NSError
        {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Auth BDD Firebase
        FirebaseApp.configure()
        
        //Auth Google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //Auth FB
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
  
        if !handled {
       
            handled = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        
        return handled
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if let error = error {
            
            Service.dismissHud(self.hud, text: "Sign up error with Google", detailText: error.localizedDescription, delay: 3)
            return
        }
        
        print("Succesfully authenticated with Google.")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (authResult, error) in
            
            if let error = error {
                
                Service.dismissHud(self.hud, text: "Sign up error Google with Firebase", detailText: error.localizedDescription, delay: 3)
                return
            }
            
            print("Succesfully authenticated with Google Firebase.")
            let userID = user.userID
            let idToken = user.authentication.idToken
            let firstname = user.profile.givenName
            let lastname = user.profile.familyName
            let email = user.profile.email
            let pictureProfile = user.profile.imageURL(withDimension: 200)
            print("\(String(describing: userID))")
            print("\(String(describing: idToken))")
            print("\(String(describing: firstname))")
            print("\(String(describing: lastname))")
            print("\(String(describing: email))")
            print("\(String(describing: pictureProfile))")            
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
       
        let firebaseAuth = Auth.auth()
        do
        {
            try firebaseAuth.signOut()
            print("Log out of Google")
        }
        catch let signOutError as NSError
        {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

