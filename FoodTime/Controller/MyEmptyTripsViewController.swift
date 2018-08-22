//
//  MyEmptyTripsViewController.swift
//  FoodTime
//
//  Created by bob on 8/20/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class MyEmptyTripsViewController: UIViewController, UITabBarDelegate {
  
    
    @IBOutlet weak var CreateTripBtn: UIButton!
    @IBOutlet weak var DescriptionTxtView: UITextView!
    @IBOutlet weak var ForYouBtn: UITabBarItem!
    @IBOutlet weak var MyNewsBtn: UITabBarItem!
    @IBOutlet weak var MyPlaces: UITabBarItem!
    @IBOutlet weak var MyProfileBtn: UITabBarItem!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var TitleLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NavigationBar.hidesBackButton = true
    }
    
   fileprivate func setupView()
   {
        TabBar.delegate = self
        NavigationBar.title = UILabels.localizeWithoutComment(key: UILabels.MyTrips)
        TitleLbl.text = UILabels.localizeWithoutComment(key: UILabels.TitleMyEmptyTripsViewController)
        DescriptionTxtView.text = UILabels.localizeWithoutComment(key: UILabels.DescriptionMyEmptyTripsViewController)
        CreateTripBtn.setTitle(UILabels.localizeWithoutComment(key: UILabels.CreateATrip), for: .normal)
   }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        self.dismiss(animated: false, completion: nil)
        
        let item = tabBar.selectedItem
        
        if item == MyNewsBtn
        {
            let desController : HomeViewController = mainStoryboard.instantiateViewController(withIdentifier: Service.HomeViewController) as! HomeViewController
            self.navigationController?.pushViewController(desController, animated: true)
        }
        else if item == MyProfileBtn
        {
            
        }
        else if item == ForYouBtn
        {
            
        }
    }
}
