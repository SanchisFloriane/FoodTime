//
//  MyEmptyTripsViewController.swift
//  FoodTime
//
//  Created by bob on 8/20/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class MyEmptyTripsViewController: UIViewController {
  
    
    @IBOutlet weak var CreateTripBtn: UIButton!
    @IBOutlet weak var DescriptionTxtView: UITextView!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var RecentlyViewedBtn: UIButton!    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var TripsBtn: UIButton!
    
    
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
