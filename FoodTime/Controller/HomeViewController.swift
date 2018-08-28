//
//  HomeViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 19/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class HomeViewController: UIViewController, UITabBarDelegate {

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
        
        self.tabBar.delegate = self
        
        setupView()
    }
    
    fileprivate func setupView()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        titlePage.title = UILabels.localizeWithoutComment(key: UILabels.NewsTitle)
        newsButton.title = UILabels.localizeWithoutComment(key: UILabels.MyNewsButton)
        placesButton.title = UILabels.localizeWithoutComment(key: UILabels.MyPlacesButton)
        recommandationsButton.title = UILabels.localizeWithoutComment(key: UILabels.RecommandationsButton)
        profileButton.title = UILabels.localizeWithoutComment(key: UILabels.MyProfileButton)
        tabBar.selectedItem = newsButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.hidesBackButton = true
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        
        self.dismiss(animated: false, completion: nil)
        
        let item = tabBar.selectedItem
        if item == placesButton
        {
            UserTrip.loadUserTrip(completion: { (userTripList) in
                
                if !(userTripList.isEmpty)
                {
                    let desController : MyListTripsViewController = mainStoryboard.instantiateViewController(withIdentifier: Service.MyListTripsViewController) as! MyListTripsViewController
                    desController.userTripList = userTripList
                    self.navigationController?.pushViewController(desController, animated: true)
                }
                else
                {
                    let desController : MyEmptyTripsViewController = mainStoryboard.instantiateViewController(withIdentifier: Service.MyEmptyTripsViewController) as! MyEmptyTripsViewController
                    self.navigationController?.pushViewController(desController, animated: true)
                }                
            })
        }
        else if item == recommandationsButton
        {
            
        }
        else if item == profileButton
        {
            
        }
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
