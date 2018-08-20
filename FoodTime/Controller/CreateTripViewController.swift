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

        // Do any additional setup after loading the view.
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
