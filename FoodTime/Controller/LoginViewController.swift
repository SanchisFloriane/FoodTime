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

class LoginViewController: UIViewController {
        
    @IBOutlet weak var signInWithFBButton: UIButton!
    
    var name: String? = ""
    var username: String? = ""
    var email: String? = ""
    var profileImage: UIImage?
    
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    func initSignInFBButton() {
        
        signInWithFBButton.setTitle("Login with Facebook", for: .normal)
       signInWithFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Service.buttonTitleFontSize)
        signInWithFBButton.setTitleColor(Service.buttonTitleColor, for: .normal)
       /* signInWithFBButton.backgroundColor = Service.buttonBackgroundColorSignInWithFacebook
        signInWithFBButton.layer.masksToBounds = true
        signInWithFBButton.layer.cornerRadius = Service.buttonCornerRadius
         signInWithFBButton.setImage(#imageLiteral(resourceName: "FacebookButton").withRenderingMode(.alwaysTemplate), for: .normal)
        signInWithFBButton.tintColor = .white
        signInWithFBButton.contentMode = .scaleAspectFit
        
       
       signInWithFBButton.addTarget(self, action: #selector(handleSignInWithFBButtonTapped), for: .touchUpInside)*/
    }
    
    @IBAction func handleSignInWithFBButtonTapped() {
        hud.textLabel.text = "Logging in with Facebook..."
        hud.show(in: view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("Succesfully logged in into Facebook.")
                self.signIntoFirebase()
            case .failed(let err):
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to get Facebook user with error: \(err)", delay: 3)
            case .cancelled:
                Service.dismissHud(self.hud, text: "Error", detailText: "Canceled getting Facebook user.", delay: 3)
            }
        }
    }
    
    fileprivate func signIntoFirebase() {
        guard let authenticationToken = AccessToken.current?.authenticationToken else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, err) in
            if let err = err {
            Service.dismissHud(self.hud, text: "Sign up error", detailText: err.localizedDescription, delay: 3)
            return
            }
            print("Succesfully authenticated with Firebase.")
            self.fetchFacebookUser()
        })
    }
    
    fileprivate func fetchFacebookUser() {
        
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequestConnection.add(graphRequest, completion: { (httpResponse, result) in
            switch result {
            case .success(response: let response):
                
                guard let responseDict = response.dictionaryValue else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                
                let json = JSON(responseDict)
                self.name = json["name"].string
                self.email = json["email"].string
                guard let profilePictureUrl = json["picture"]["data"]["url"].string else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                guard let url = URL(string: profilePictureUrl) else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                
                URLSession.shared.dataTask(with: url) { (data, response, err) in
                    if err != nil {
                        guard let err = err else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                        Service.dismissHud(self.hud, text: "Fetch error", detailText: err.localizedDescription, delay: 3)
                        return
                    }
                    guard let data = data else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                    self.profileImage = UIImage(data: data)
                    self.saveUserIntoFirebaseDatabase()
                    
                    }.resume()
                
                break
            case .failed(let err):
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to get Facebook user with error: \(err)", delay: 3)
                break
            }
        })
        graphRequestConnection.start()
    }
    
    fileprivate func saveUserIntoFirebaseDatabase() {
        
        guard let uid = Auth.auth().currentUser?.uid,
            let name = self.name,
            let username = self.username,
            let email = self.email,
            let profileImage = profileImage,
            let profileImageUploadData = UIImageJPEGRepresentation(profileImage, 0.3) else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user.", delay: 3); return }
        let fileName = UUID().uuidString
        
        let storageItem = Storage.storage().reference().child("profileImages").child(fileName)
        var profileImageUrl: String?
        storageItem.putData(profileImageUploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user with error: \(err)", delay: 3);
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
                        profileImageUrl = url?.absoluteString
                        print("Successfully uploaded profile image into Firebase storage with URL:", profileImageUrl!)
                    }
                })
            }
        }
        
        let dictionaryValues = ["name": name,
                                "email": email,
                                "username": username,
                                "profileImageUrl": profileImageUrl]
        let values = [uid : dictionaryValues]
            
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user info with error: \(err)", delay: 3)
                return
            }
            print("Successfully saved user info into Firebase database")
            // after successfull save dismiss the welcome view controller
            self.hud.dismiss(animated: true)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    fileprivate func setupViews()
    {
        initSignInFBButton()
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

}
