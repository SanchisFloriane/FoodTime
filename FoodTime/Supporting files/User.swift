//
//  User.swift
//  FoodTime
//
//  Created by floriane sanchis on 19/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    //Attributes in DB
    var lastname: String?
    var firstname: String?
    var pseudo: String?
    var email: String?
    var profilePictureFIRUrl: String?
    var fbAccount: String! = "false"
    var googleAccount: String! = "false"
    
    //Attributes no in DB
    var profilePicture: UIImage?
    
    init() {}

    init(lastname: String?, firstname: String?, pseudo: String?, email: String?, profilePictureFIRUrl: String?, fbAccount: String!, googleAccount: String!) {
        
        self.lastname = lastname
        self.firstname = firstname
        self.pseudo = pseudo
        self.email = email
        self.profilePictureFIRUrl = profilePictureFIRUrl
        self.fbAccount = fbAccount
        self.googleAccount = googleAccount
    }
    
    func getData() -> [String: String]
    {
        return [ModelDB.User_lastname: self.lastname ?? "",
                ModelDB.User_firstname: self.firstname ?? "",
                ModelDB.User_pseudo : self.pseudo ?? "",
                ModelDB.User_email: self.email ?? "",
                ModelDB.User_profilePictureFIRUrl : self.profilePictureFIRUrl ?? "",
                ModelDB.User_fbAccount : self.fbAccount,
                ModelDB.User_googleAccount : self.googleAccount]
    }
}
