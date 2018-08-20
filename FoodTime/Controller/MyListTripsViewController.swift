//
//  MyListTripsViewController.swift
//  FoodTime
//
//  Created by bob on 8/20/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class MyListTripsViewController: UIViewController {

    @IBOutlet weak var RecentlyViewedBtn: UIButton!
    @IBOutlet weak var SortBtn: UIButton!
    @IBOutlet weak var TripsBtn: UIButton!
    @IBOutlet weak var TripsTableView: UITableView!
    
    var userTripList : [UserTrip] = [UserTrip]()
    var tripList : [Trip] = [Trip]()
    
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
