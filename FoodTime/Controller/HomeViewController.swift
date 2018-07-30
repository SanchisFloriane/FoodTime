//
//  HomeViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 19/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        
        self.userTastesExist(completion: { (tastesExist) in
            
            if !tastesExist
            {
                //Go to choice preferences
                let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
                let desController : UIViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.ChoiceUserPageViewController) as! ChoiceUserPageViewController
                desController.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationController?.pushViewController(desController, animated: true)
            }
        })
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    fileprivate func userTastesExist(completion: @escaping (Bool) -> ())
    {
        var tastesExits = false
        Database.database().reference().child("\(ModelDB.tastes)/\(Auth.auth().currentUser!.uid)").observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                print("user tastes exists")
                tastesExits = true
            }
            completion(tastesExits)
        })
    }
}
