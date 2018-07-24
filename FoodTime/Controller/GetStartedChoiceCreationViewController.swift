//
//  GetStartedChoiceCreationViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 23/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import FacebookCore
import FacebookLogin
import FirebaseStorage
import FirebaseDatabase
import GoogleSignIn
import FBSDKLoginKit

class GetStartedChoiceCreationViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate  {

    @IBOutlet weak var EmailButton: UIButton!
    @IBOutlet weak var FBButton: FBSDKLoginButton!
    @IBOutlet weak var GoogleButton: GIDSignInButton!
    @IBOutlet weak var TermsPrivatePolicyButton: UIButton!
    
    var currentUser: User?
    var newUser: Bool = true
    var values : [String : [String: String]]?
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    
    fileprivate func setupFBButton() {
        
        FBButton.setTitle(UILabels().localizeWithoutComment(key: UILabels().FBSignUpButton), for: .normal)
        FBButton.readPermissions = ["email", "public_profile"]
        FBButton.delegate = self
    }
    
    fileprivate func setupGoogleButton()
    {        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendGoogleDataDelegateToViewController(not:)), name: Service.sendGoogleDataToLoginViewController, object: nil)
    }
    
    fileprivate func setupViews()
    {
         EmailButton.setTitle(UILabels().localizeWithoutComment(key: UILabels().EmailSignInButton), for: .normal)
        TermsPrivatePolicyButton.setTitle(UILabels().localizeWithoutComment(key: UILabels().TermsPrivatePolicyButton), for: .normal)
        TermsPrivatePolicyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        setupFBButton()
        setupGoogleButton()
        
        self.view.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            print("Succesfully authenticated with FB Firebase.")
            
            self.userExists()
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "email, first_name, last_name, picture.type(large)"]).start{ (connection, result, error) in
                if error != nil {
                    Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user. \(String(describing: error))", delay: 3)
                    return
                }
                
                if let result = result as? [String: Any?] {
                    
                    self.currentUser = User(lastname: result["last_name"] as? String, firstname: result["first_name"] as? String, pseudo: nil, email: result["email"] as? String, password: nil, profilePictureFIRUrl: nil, fbAccount: true, googleAccount: false)
                    
                    if let picture = result["picture"] as? NSDictionary {
                        if let data = picture["data"] as? NSDictionary {
                            if let profilePictureUrl = data["url"] as? String {
                                guard let pictureUrl = URL(string: profilePictureUrl) else {
                                    Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3)
                                    return
                                }
                                let imageData = NSData(contentsOf: pictureUrl) as Data?
                                if let imgData = imageData
                                {
                                    let userProfileImage = UIImage(data: imgData)
                                    self.currentUser!.profilePicture = userProfileImage
                                    self.uploadData()
                                }
                            }
                        }
                    } else {
                        self.uploadData()
                    }
                }
                
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
    
    @objc func sendGoogleDataDelegateToViewController(not: Notification)
    {
        if let userInfo = not.userInfo
        {
            if let user = userInfo["user"] as? User
            {
                self.currentUser = user
                if let pictureUrl = self.currentUser!.profilePictureFIRUrl {
                    let imageData = NSData(contentsOf: URL(string: pictureUrl)!) as Data?
                    if let imgData = imageData
                    {
                        let userProfileImage = UIImage(data: imgData)
                        self.currentUser!.profilePicture = userProfileImage
                    }
                }
            }
        }
        
        self.userExists()
        self.uploadData()
    }
    
    
    fileprivate func uploadData()
    {
        guard let uid = Auth.auth().currentUser?.uid,
            let email = self.currentUser!.email else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to upload data user.", delay: 3); return}
        let firstname = self.currentUser!.firstname
        let lastname = self.currentUser!.lastname
        let pseudo = self.currentUser!.pseudo
        let password = self.currentUser!.password
        let fbAccount = self.currentUser!.fbAccount
        let googleAccount = self.currentUser!.googleAccount
        
        var profileImageUploadData : Data?
        var profileImageUrl: String?
        var dictionaryValues: [String: String] = [:]
        if let profileImage = self.currentUser!.profilePicture
        {
            profileImageUploadData = UIImageJPEGRepresentation(profileImage, 0.3)
            
            let fileName = uid
            
            let storageItem = StorageReference().child("profileImages").child(fileName)
            storageItem.putData(profileImageUploadData!, metadata: nil) { (metadata, error) in
                
                if let err = error {
                    Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save profile picture user with error: \(err)", delay: 3)
                    return
                }
                else
                {
                    storageItem.downloadURL(completion: { (url, error) in
                        if error != nil {
                            Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save profile picture user.", delay: 3)
                            return
                        }
                        
                        if url != nil {
                            profileImageUrl = url!.absoluteString
                            print("Successfully uploaded profile picture user into Firebase storage")
                            
                            dictionaryValues = ["lastname": lastname ?? "",
                                                "firstname": firstname ?? "",
                                                "email": email,
                                                "password": password ?? "",
                                                "pseudo": pseudo ?? "",
                                                "profilePictureFIRUrl": profileImageUrl ?? "",
                                                "fbAccount": fbAccount.description,
                                                "googleAccount": googleAccount.description ]
                            
                            self.values = [uid : dictionaryValues]
                            self.saveUser()
                        }
                    })
                }
            }
        }
        else
        {
            dictionaryValues = ["lastname": lastname ?? "",
                                "firstname": firstname ?? "",
                                "email": email,
                                "password": password ?? "",
                                "pseudo": pseudo ?? "",
                                "profilePictureFIRUrl": profileImageUrl ?? "",
                                "fbAccount": fbAccount.description,
                                "googleAccount": googleAccount.description ]
            
            self.values = [uid : dictionaryValues]
            self.saveUser()
        }
    }
    
    fileprivate func userExists()
    {
        self.newUser = true
        
        Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)").observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                self.newUser = false
                print("user exists")
            }
        })
    }
    
    fileprivate func saveUser() {
        
        Database.database().reference().child("users").updateChildValues(self.values!, withCompletionBlock: { (err, ref) in
            if let err = err {
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user info with error: \(err)", delay: 3)
                return
            }
            print("Successfully saved user info into Firebase database")
            
            // after successfull save dismiss the welcome view controller
            self.hud.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
            
            let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
            let desController : UIViewController!
            
            if self.newUser {
                //Go to choice preferences
                desController = mainStoryboard.instantiateViewController(withIdentifier: Service.ChoicePlaceViewController) as! ChoicePlaceViewController
            }
            else
            {
                //Go to Home page
                desController = mainStoryboard.instantiateViewController(withIdentifier: Service.HomeViewController) as! HomeViewController
            }
            
            self.navigationController?.pushViewController(desController, animated: true)
        })
    }
}
