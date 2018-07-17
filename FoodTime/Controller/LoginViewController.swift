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
    @IBOutlet weak var TermsPrivatePolicyButton: UIButton!
    @IBOutlet weak var EmailConnectionButton: UIButton!
    
    var lastname: String? = ""
    var firstname: String? = ""
    var id: String? = ""
    var email: String? = ""
    var profileImage: UIImage?
    var values : [String : [String: String?]]?
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
        
        if AccessToken.current != nil {
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, picture.type(large)"]).start({ (urlResponse, requestResult) in
                switch requestResult {
                case .success(let response):
                    if let responseDictionary = response.dictionaryValue {
                       
                        self.id = responseDictionary["id"] as? String
                        self.email = responseDictionary["email"] as? String
                        self.firstname = responseDictionary["first_name"] as? String
                        self.lastname = responseDictionary["last_name"] as? String
                        
                        if let picture = responseDictionary["picture"] as? NSDictionary {
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
                                        self.profileImage = userProfileImage
                                    }
                                    
                                    /*URLSession.shared.dataTask(with: pictureUrl) { (data, response, error) in
                                        if error != nil {
                                            guard let error = error else {
                                                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user", delay: 3)
                                                return
                                            }
                                            Service.dismissHud(self.hud, text: "Fetch error", detailText: error.localizedDescription, delay: 3)
                                            return
                                        }
                                        guard let data = data else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user", delay: 3)
                                            return
                                        }*/
                                        self.saveUserIntoFirebaseDatabase()
                                    //}.resume()
                                }
                            }
                        }
                    }
                case .failed(let error):
                    Service.dismissHud(self.hud, text: "Error", detailText: "Failed to get Facebook user with error: \(error)", delay: 3)
                    break
                }
            })
        }
    }
    
    private func uploadImage(completion: @escaping (_ success:Bool) -> Void)
    {
        guard let uid = Auth.auth().currentUser?.uid,
            let id = self.id,
            let email = self.email,
            let firstname = self.firstname,
            let lastname = self.lastname,
            let profileImage = self.profileImage,
            let profileImageUploadData = UIImageJPEGRepresentation(profileImage, 0.3) else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user.", delay: 3); return}
        print(uid)
        let fileName = UUID().uuidString
        
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
                        print("Successfully uploaded profile image into Firebase storage with URL:", profileImageUrl!)
                    }
                    
                    let dictionaryValues = ["id": id,
                                            "email": email,
                                            "firstname": firstname,
                                            "lastname": lastname,
                                            "profileImageUrl": profileImageUrl]
                    
                    self.values = [uid : dictionaryValues]
                    completion(true)
                })
            }
        }
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
                })
            }
        }
        
    }
    
    fileprivate func setupViews()
    {
        signInWithFBButton.setTitle(NSLocalizedString("FBConnectionButton", comment: ""), for: .normal)
        print(NSLocalizedString("FBConnectionButton", comment: ""))
        TermsPrivatePolicyButton.setTitle(UILabels().localizeWithoutComment(key: UILabels().TermsPrivatePolicyButton), for: .normal)
        EmailConnectionButton.setTitle(UILabels().localizeWithoutComment(key: UILabels().EmailConnectionButton), for: .normal)
        
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
