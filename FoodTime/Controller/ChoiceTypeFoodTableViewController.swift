//
//  ChoiceTypeFoodViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 24/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase

class ChoiceTypeFoodViewController: UITableViewController, PageObservation {

    @IBOutlet weak var typeFoodTableView: UITableView!
    
    var parentPageViewController : UIPageViewController!
    var listTypeFood : [String] = [String]()
    
    func getParentUIPageViewController(parentRef: UIPageViewController) {
        parentPageViewController = parentRef
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTypeFood()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func getTypeFood()
    {
        Database.database().reference().child("\(ModelDB.typeFood)/\(Service.LanguageApp)").queryOrderedByValue().observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                let listChildren = snapchot.children
                while let child = listChildren.nextObject() as? DataSnapshot
                {
                    print(child.value!)
                }
                
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func backPage() {
        
        let parent = parentPageViewController as! ChoiceUserPageViewController
        parentPageViewController.goToPreviousPage()
        parent.pageControl.currentPage = 0
        
        
    }
    
}
