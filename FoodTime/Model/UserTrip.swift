//
//  UserTrip.swift
//  FoodTime
//
//  Created by bob on 8/14/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserTrip {
    
    //Attributes in DB
    var idUser: String?
    var idTrip: String?
    
    //Attributes no in DB
    
    init() {}
    
    init(idUser: String?, idTrip: String?) {
        
        self.idUser = idUser
        self.idTrip = idTrip
    }
    
    func getData() -> [String: String]
    {
        return [ModelDB.UserTrip_idUser: self.idUser ?? "",
                ModelDB.UserTrip_idTrip : self.idTrip ?? ""]
    }
    
    static func loadUserTrip(completion:@escaping ([UserTrip])->())
    {
        var userTripList : [UserTrip] = [UserTrip]()
        let idUser = Auth.auth().currentUser!.uid
        
        //Get all trips of the current user
        Database.database().reference().child("\(ModelDB.user_trip)/\(idUser)").observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                let listChildren = snapchot.children
                while let child = listChildren.nextObject() as? DataSnapshot
                {
                    let idTrip = child.value as? String
                    userTripList.append(UserTrip(idUser: idUser, idTrip: idTrip!))
                }
                completion(userTripList)
            }
            else
            {
                completion(userTripList)
            }
        })
    }
}
