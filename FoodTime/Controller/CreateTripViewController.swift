//
//  CreateTripViewController.swift
//  FoodTime
//
//  Created by bob on 8/20/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class CreateTripViewController: UIViewController {

    @IBOutlet weak var CancelBarBtn: UIBarButtonItem!
    @IBOutlet weak var DetailsLbl: UILabel!
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var EndDateLbl: UILabel!
    @IBOutlet weak var NavigationBarCreateTrip: UINavigationItem!
    @IBOutlet weak var SaveBarBtn: UIBarButtonItem!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var StartDateLbl: UILabel!
    @IBOutlet weak var TripNameTxtField: UITextField!
    @IBOutlet weak var TripNameLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    fileprivate func setupView()
    {        
        NavigationBarCreateTrip.title = UILabels.localizeWithoutComment(key: UILabels.CreateATrip)
        CancelBarBtn.title = UILabels.localizeWithoutComment(key: UILabels.Cancel)
        SaveBarBtn.title = UILabels.localizeWithoutComment(key: UILabels.Save)
        DetailsLbl.text = UILabels.localizeWithoutComment(key: UILabels.Details)
        TripNameLbl.text = UILabels.localizeWithoutComment(key: UILabels.NameTrip)
        TripNameTxtField.placeholder = UILabels.localizeWithoutComment(key: UILabels.EnterAName)
        StartDateLbl.text = UILabels.localizeWithoutComment(key: UILabels.StartDate)
        EndDateLbl.text = UILabels.localizeWithoutComment(key: UILabels.StartDate)
    }

}
