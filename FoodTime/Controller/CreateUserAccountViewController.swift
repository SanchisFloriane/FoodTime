//
//  CreateUserAccountViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 23/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase

class CreateUserAccountViewController: UIViewController {
    
    @IBOutlet weak var CreationBarButton: UIBarButtonItem!
    @IBOutlet weak var EmailTxtView: UITextField!
    @IBOutlet weak var PwdConfirmTxtView: UITextField!
    @IBOutlet weak var PwdTxtView: UITextField!
    @IBOutlet weak var TitleView: UILabel!
    
    var currentUser: User?
    var values : [String : [String: String]]?
    var isExists : Bool = false
    
    
    fileprivate func clearTextView()
    {
        EmailTxtView.text = ""
        PwdTxtView.text = ""
        PwdConfirmTxtView.text = ""
        
        EmailTxtView.placeholder = UILabels.localizeWithoutComment(key: UILabels.Email)
        PwdTxtView.placeholder = UILabels.localizeWithoutComment(key: UILabels.Password)
        PwdConfirmTxtView.placeholder = UILabels.localizeWithoutComment(key: UILabels.PasswordConfirmation)
        TitleView.text = UILabels.localizeWithoutComment(key: UILabels.CreateUserAccount)
    }
    
    fileprivate func setupView(){
        
        clearTextView()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        if EmailTxtView.text?.count == 0 || PwdTxtView.text?.count == 0 || PwdConfirmTxtView.text?.count == 0
        {
            CreationBarButton.isEnabled = false
        }
    }
    
    @IBAction func checkEnabledLoginbutton() {
        
        if EmailTxtView.text?.count == 0 || PwdTxtView.text?.count == 0 || PwdConfirmTxtView.text?.count == 0
        {
            CreationBarButton.isEnabled = false
        }
        else
        {
            CreationBarButton.isEnabled = true
        }
    }
    
    fileprivate func checkFormatPassword() -> Bool
    {
        var returnValue = true
        let pwdRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,}$"
        do
        {
            let regex = try NSRegularExpression(pattern: pwdRegEx)
            let nsString = PwdTxtView.text! as NSString
            let results = regex.matches(in: PwdTxtView.text! , range: NSRange(location: 0, length: nsString.length))
            
            if results.count ==  0
            {
                returnValue = false
            }
        }
        catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return returnValue
    }
    
    fileprivate func checkPassword() -> Bool
    {
        var check : Bool = false
        
        
        if checkFormatPassword()
        {
            if PwdTxtView.text!.elementsEqual(PwdConfirmTxtView.text!)
            {
                check = true
            }
            else
            {
                Service.showAlert(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.ErrorTitle), message:  UIMessages.localizeWithoutComment(key: UIMessages.ErrorPassword))
            }
        }
        else
        {
            Service.showAlert(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.ErrorTitle), message:  UIMessages.localizeWithoutComment(key: UIMessages.ErrorFormatPassword))
        }
        
        return check
    }
    
    fileprivate func isValidEmailAddress(emailAddressString: String) -> Bool
    {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do
        {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count ==  0
            {
                returnValue = false
            }
        }
        catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        if !returnValue
        {
            Service.showAlert(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.ErrorTitle), message:  UIMessages.localizeWithoutComment(key: UIMessages.ErrorEmail))
        }
        return returnValue
    }
    
    fileprivate func checkFields(completion:@escaping (Bool)->())
    {
        var check : Bool = false
        
        if isValidEmailAddress(emailAddressString: EmailTxtView.text!)
        {
            if checkPassword()
            {
                self.isUserExists(completion: { (userExists) in
                    
                    if userExists
                    {
                        Service.showAlert(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.ErrorTitle), message:  UIMessages.localizeWithoutComment(key: UIMessages.ErrorEmailExists))
                        completion(check)
                    }
                    else
                    {
                        check = true
                        completion(check)
                    }
                })
            }
            else
            {
                completion(check)
            }
        }
        else
        {
            completion(check)
        }
    }
    
    @IBAction func createUserAccount() {
        
        self.checkFields(completion: { (check) in
            
            if check
            {
                Auth.auth().createUser(withEmail: self.EmailTxtView.text!, password: self.PwdTxtView.text!) { (authResult, error) in
                
                    if error != nil {
                        if self.isExists
                        {
                            Service.showAlert(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.ErrorTitle), message:  UIMessages.localizeWithoutComment(key: UIMessages.ErrorEmailExists))
                        }
                        else
                        {
                            print("Error creation user with error : \(String(describing: error?.localizedDescription))")
                        }
                        return
                    }
                
                    self.uploadData()
                    print("Creation user account succeed !")
                }
            }
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupView()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setupView()
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    fileprivate func uploadData()
    {
        self.currentUser = User(lastname: nil, firstname: nil, pseudo: nil, email: EmailTxtView.text!, profilePictureFIRUrl: nil, fbAccount: false.description, googleAccount: false.description)
        
        let uid : String! = Auth.auth().currentUser!.uid
        
        self.values = [uid : self.currentUser!.getData()]
        self.saveUser()
    }
    
    fileprivate func isUserExists(completion:@escaping (Bool)->())
    {
        self.isExists = false
        
        Auth.auth().fetchProviders(forEmail: EmailTxtView.text!, completion: { (auth, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
               
            if auth != nil
            {
                self.isExists = true
                completion(self.isExists)
            }
            else
            {
                completion(self.isExists)
            }
        })
    }
    
    fileprivate func saveUser() {
        
        Database.database().reference().child("\(ModelDB.users)").updateChildValues(self.values!, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to save user info with error: \(err)")
                return
            }
            print("Successfully saved user info into Firebase database")
            
            // after successfull save dismiss the welcome view controller
            self.dismiss(animated: true, completion: nil)
            
            let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
            let desController : UIViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.ChoiceUserPageViewController) as! ChoiceUserPageViewController
            
            self.navigationController?.pushViewController(desController, animated: true)
        })
    }
    
    @IBAction func dismiss() {
        navigationController?.popViewController(animated: true)
    }
}
