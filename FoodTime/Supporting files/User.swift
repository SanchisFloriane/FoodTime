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
    var password: String?
    var profilePictureFIRUrl: String?
    var fbAccount: Bool = false
    var googleAccount: Bool = false
    
    //Attributes no in DB
    var profilePicture: UIImage?
    
    init() {
        
    }

    init(lastname: String?,firstname: String?,pseudo: String?,email: String?,password: String?,profilePictureFIRUrl: String?,fbAccount: Bool, googleAccount: Bool) {
        
        self.lastname = lastname
        self.firstname = firstname
        self.pseudo = pseudo
        self.email = email
        self.password = password
        self.profilePictureFIRUrl = profilePictureFIRUrl
        self.fbAccount = fbAccount
        self.googleAccount = googleAccount
    }
}
