//
//  SearchPlaceDetailViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 01/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class SearchPlaceDetailViewController: UIViewController {
    
    @IBOutlet weak var filterListButton: UIBarButtonItem!
    @IBOutlet weak var newsButton: UITabBarItem!
    
    @IBOutlet weak var placesButton: UITabBarItem!
    @IBOutlet weak var profileButton: UITabBarItem!
    @IBOutlet weak var recommandationsButton: UITabBarItem!
    @IBOutlet weak var tablePlaceView: UITableView!
    @IBOutlet weak var titlePage: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupView()
    }

    fileprivate func setupView()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        titlePage.title = UILabels.localizeWithoutComment(key: UILabels.TitleSearchPlaceDetailViewController)
        
        newsButton.title = UILabels.localizeWithoutComment(key: UILabels.MyNewsButton)
        placesButton.title = UILabels.localizeWithoutComment(key: UILabels.MyPlacesButton)
        recommandationsButton.title = UILabels.localizeWithoutComment(key: UILabels.RecommandationsButton)
        profileButton.title = UILabels.localizeWithoutComment(key: UILabels.MyProfileButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
