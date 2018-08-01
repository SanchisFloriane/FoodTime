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

    @IBOutlet weak var newsButton: UITabBarItem!
    @IBOutlet weak var placesButton: UITabBarItem!
    @IBOutlet weak var profileButton: UITabBarItem!
    @IBOutlet weak var recommandationsButton: UITabBarItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var titlePage: UINavigationItem!
    
    
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
        setupView()
    }

    fileprivate func setupView()
    {
        titlePage.title = UILabels.localizeWithoutComment(key: UILabels.NewsTitle)
        newsButton.title = UILabels.localizeWithoutComment(key: UILabels.MyNewsButton)
        placesButton.title = UILabels.localizeWithoutComment(key: UILabels.MyPlacesButton)
        recommandationsButton.title = UILabels.localizeWithoutComment(key: UILabels.RecommandationsButton)
        profileButton.title = UILabels.localizeWithoutComment(key: UILabels.MyProfileButton)        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.hidesBackButton = true
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
