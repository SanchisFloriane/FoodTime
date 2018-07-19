//
//  LoginViewController.swift
//  FoodTime
//
//  Created by bob on 7/11/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import FacebookCore
import FacebookLogin
import SwiftyJSON
import FirebaseStorage
import FirebaseDatabase
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var TermsPrivatePolicyButton: UIButton!
    
    var currentUser: User?
    var newUser: Bool = true
    var values : [String : [String: String?]]?
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    let GoogleButton : GIDSignInButton = GIDSignInButton()
    let FBButton : FBSDKLoginButton = FBSDKLoginButton()
    
    fileprivate func setupFBButton() {
        
        view.addSubview(FBButton)

        //enables auttolayout for the FBButton
        FBButton.translatesAutoresizingMaskIntoConstraints = false
        FBButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        FBButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        FBButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        FBButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        
        FBButton.readPermissions = ["email", "public_profile"]
        FBButton.delegate = self
    }
    
    fileprivate func setupGoogleButton()
    {
        view.addSubview(GoogleButton)
        
        //enables auttolayout for the FBButton
        GoogleButton.translatesAutoresizingMaskIntoConstraints = false
        GoogleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        GoogleButton.centerYAnchor.constraint(equalTo: FBButton.centerYAnchor, constant: 75).isActive = true
        GoogleButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        GoogleButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    private func uploadImage(completion: @escaping (_ success:Bool) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid,
        let id = self.currentUser!.idUser,
        let email = self.currentUser!.email,
        let firstname = self.currentUser!.firstname,
        let lastname = self.currentUser!.lastname,
        let profileImage = self.currentUser!.profilePicture,
        let profileImageUploadData = UIImageJPEGRepresentation(profileImage, 0.3) else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user.", delay: 3); return}
        
        let fileName = uid
        
        let storageItem = StorageReference().child("profileImages").child(fileName)
        var profileImageUrl: String?
        storageItem.putData(profileImageUploadData, metadata: nil) { (metadata, error) in
            
            if let err = error {
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user with error: \(err)", delay: 3)
                return
            }
            else
            {
                storageItem.downloadURL(completion: { (url, error) in
                    if error != nil {
                        Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user.", delay: 3)
                        return
                    }
                    
                    if url != nil {
                        profileImageUrl = url!.absoluteString
                        print("Successfully uploaded profile image into Firebase storage")
                    }
                    
                    let dictionaryValues = ["idUser": id,
                                            "lastname": lastname,
                                            "firstname": firstname,
                                            "email": email,
                                            "profilePictureFIRUrl": profileImageUrl]
                    
                    self.values = [uid : dictionaryValues]
                    completion(true)
                })
            }
        }
    }

    fileprivate func userExists(uid: String!)
    {
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { snapchot in
        
            if snapchot.hasChild(uid)
            {
                self.newUser = false
                print("User exists")
            }
            else
            {
                self.newUser = true
            }
        })
    }
    
    fileprivate func saveUserIntoFirebaseDatabase() {
        
        uploadImage{ (success) in
            if success {
                print("Upload finished")
                
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
        
    }
    
    fileprivate func setupViews()
    {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func dismiss() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
            
            //Find user by email :
            self.userExists(uid: Auth.auth().currentUser!.uid)
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, email, first_name, last_name, picture.type(large)"]).start{ (connection, result, error) in
                if error != nil {
                    Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user. \(String(describing: error))", delay: 3)
                    return
                }
                
                if let result = result as? [String: Any?] {
                    
                    self.currentUser = User(idUser: result["id"] as? String, lastname: result["last_name"] as? String, firstname: result["first_name"] as? String, pseudo: nil, email: result["email"] as? String, password: nil, profilePictureFIRUrl: nil, fbAccount: true, googleAccount: false)
                    
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
                                }
                                
                                self.saveUserIntoFirebaseDatabase()
                            }
                        }
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

}
