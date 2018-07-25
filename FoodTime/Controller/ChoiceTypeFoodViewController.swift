//
//  ChoiceTypeFoodViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 24/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class ChoiceTypeFoodViewController: UIViewController, PageObservation {

    
    @IBOutlet weak var listTypeFood: UITableView!
    
    var parentPageViewController : UIPageViewController!
    
    func getParentUIPageViewController(parentRef: UIPageViewController) {
        parentPageViewController = parentRef
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPage() {
        
        let parent = parentPageViewController as! ChoiceUserPageViewController
        parentPageViewController.goToPreviousPage()
        parent.pageControl.currentPage = 0
        
        
    }
    
}
