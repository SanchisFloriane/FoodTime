//
//  MyListTripsViewController.swift
//  FoodTime
//
//  Created by bob on 8/20/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class MyListTripsViewController: UIViewController, UITabBarDelegate {
   
    @IBOutlet weak var CancelBtn: UIBarButtonItem!
    @IBOutlet weak var ForYouBtn: UITabBarItem!
    @IBOutlet weak var MyNewsBtn: UITabBarItem!
    @IBOutlet weak var MyPlacesBtn: UITabBarItem!
    @IBOutlet weak var MyProfileBtn: UITabBarItem!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var RecentlyViewedBtn: UIButton!
    @IBOutlet weak var SortBtn: UIButton!
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var TripsBtn: UIButton!
    @IBOutlet weak var TripsTableView: UITableView!
    
    var userTripList : [UserTrip] = [UserTrip]()
    var tripList : [Trip] = [Trip]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    fileprivate func setupView()
    {
        TabBar.delegate = self
        
        MyNewsBtn.title = UILabels.localizeWithoutComment(key: UILabels.MyNewsButton)
        MyPlacesBtn.title = UILabels.localizeWithoutComment(key: UILabels.MyPlacesButton)
        ForYouBtn.title = UILabels.localizeWithoutComment(key: UILabels.RecommandationsButton)
        MyProfileBtn.title = UILabels.localizeWithoutComment(key: UILabels.MyProfileButton)
        
        NavigationBar.title = UILabels.localizeWithoutComment(key: UILabels.MyTrips)
        TripsBtn.setTitle(UILabels.localizeWithoutComment(key: UILabels.TripsBtn), for: .normal)
        TripsBtn.setTitleColor(UIColor.white, for: .selected)
        TripsBtn.setTitleColor(UIColor.orange, for: .normal)
        RecentlyViewedBtn.setTitle(UILabels.localizeWithoutComment(key: UILabels.RecentlyViewedBtn), for: .normal)
        RecentlyViewedBtn.setTitleColor(UIColor.white, for: .selected)
        RecentlyViewedBtn.setTitleColor(UIColor.orange, for: .normal)
        //RecentlyViewedBtn.isEnabled = false
        let sortTitle = "\(UILabels.localizeWithoutComment(key: UILabels.SortedBy)) \(UILabels.localizeWithoutComment(key: UILabels.Alphabetical))"
        SortBtn.setTitle(sortTitle, for: .normal)
        
        TripsBtn.isSelected = true
        SortBtn.contentHorizontalAlignment = .left
        SortBtn.contentEdgeInsets.left = CancelBtn.imageInsets.left
        TabBar.selectedItem = MyPlacesBtn
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
        
    @IBAction func buttonTapped(sender: UIButton) {
        
        if sender == TripsBtn || sender == RecentlyViewedBtn
        {
            if TripsBtn.backgroundColor == UIColor.orange {
                TripsBtn.backgroundColor = UIColor.groupTableViewBackground
                TripsBtn.isSelected = false
                RecentlyViewedBtn.backgroundColor = UIColor.orange
                RecentlyViewedBtn.isSelected = true
            }
            else
            {
                TripsBtn.backgroundColor = UIColor.orange
                TripsBtn.isSelected = true
                RecentlyViewedBtn.backgroundColor = UIColor.groupTableViewBackground
                RecentlyViewedBtn.isSelected = false
            }
        }
    }
    
    
    @IBAction func sortTable() {
        
        let alert = UIAlertController(title: UILabels.localizeWithoutComment(key: UILabels.SortByAlert), message: "", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: UILabels.localizeWithoutComment(key: UILabels.Alphabetical), style: .default, handler: { (action) in
        
        }))
        
        alert.addAction(UIAlertAction(title: UILabels.localizeWithoutComment(key: UILabels.Recent), style: .default, handler: { (action) in
            
        }))
        
        let cancel = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.Cancel), style: .cancel)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension MyListTripsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = TripsTableView.dequeueReusableCell(withIdentifier: Service.MyListTripsIdCell) as! MyListTripsTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.tripList.count
    }
}

