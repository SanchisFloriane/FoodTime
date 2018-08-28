//
//  ManageTripEmpt/Users/florianesanchis/Documents/FoodTime/FoodTime/New Group1/Base.lproj/Main.storyboardyViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 27/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class ManageTripEmptyViewController: UIViewController {


    @IBOutlet weak var addTripButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var manageButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBarPage: UINavigationItem!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var descriptionPageTxtView: UITextView!
    
    var trip : Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    fileprivate func setupView()
    {
        mapButton.isEnabled = false
        self.addTripButton.titleLabel?.text = UILabels.localizeWithoutComment(key: UILabels.AddTrip)
        self.mapButton.titleLabel?.text = UILabels.localizeWithoutComment(key: UILabels.Map)
        self.navigationBarPage.title = UILabels.localizeWithoutComment(key: UILabels.ManageMyTrip)
        self.descriptionPageTxtView.text = UILabels.localizeWithoutComment(key: UILabels.DescriptionPageManageTripEmptyViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func manageTrip(_ sender: UIBarButtonItem) {
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : ModifyTripViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.ModifyTripViewController) as! ModifyTripViewController
        desController.trip = self.trip
        self.navigationController?.pushViewController(desController, animated: true)
    }
    
}
