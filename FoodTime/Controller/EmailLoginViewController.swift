//
//  EmailLoginViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 23/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase

class EmailLoginViewController: UIViewController, UITextViewDelegate {

   
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var emailTxtView: UITextField!
    @IBOutlet weak var pwdTxtView: UITextField!
    @IBOutlet weak var loginBarButton: UIBarButtonItem!
    
    
    @IBAction func login(_ sender: UIBarButtonItem) {
        
        let email : String! = emailTxtView.text!
        let password : String! = pwdTxtView.text!
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error == nil && user != nil
            {
                // after successfull login dismiss the welcome view controller
                self.dismiss(animated: true, completion: nil)
                
                let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
                
                let desController : UIViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.HomeViewController) as! HomeViewController
                
                self.navigationController?.pushViewController(desController, animated: true)
            }
            else if user == nil
            {
                Service.showAlert(on: self, style: .alert, title: "Error", message: "The email/password is invalid.")
            }
            else
            {
                print("Failed to log in with error: \(String(describing: error))")
            }
        
        })
    }
    
    fileprivate func clearTextView()
    {
        emailTxtView.text = ""
        pwdTxtView.text = ""
        
        emailTxtView.placeholder = UILabels().localizeWithoutComment(key: UILabels().Email)
        pwdTxtView.placeholder = UILabels().localizeWithoutComment(key: UILabels().Password)
        titleLbl.text = UILabels().localizeWithoutComment(key: UILabels().EmailTitle)
    }
    
    fileprivate func setupView(){
    
        clearTextView()
        
        if emailTxtView.text?.count == 0 || pwdTxtView.text?.count == 0
        {
           loginBarButton.isEnabled = false
        }
    }
    
    @IBAction func checkEnabledLoginbutton(_ sender: UITextField) {
    
        if emailTxtView.text?.count == 0 || pwdTxtView.text?.count == 0
        {
            loginBarButton.isEnabled = false
        }
        else {
            loginBarButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
