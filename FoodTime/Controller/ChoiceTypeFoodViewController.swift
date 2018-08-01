//
//  ChoiceTypeFoodViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 24/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase
import UICheckbox_Swift

class ChoiceTypeFoodViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PageObservation {
    
    @IBOutlet weak var descriptionPage: UILabel!
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var typeFoodTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var parentPageViewController : UIPageViewController!
    var listTypeFood : [String] = [String]()
    var listTypeFoodSelected : [String] = [String]()
    
    func getParentUIPageViewController(parentRef: UIPageViewController)
    {
        parentPageViewController = parentRef
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView()
    {
        nextButton.isHidden = true
        
        titlePage.text = UILabels.localizeWithoutComment(key: UILabels.TitlePageChoiceTypeFoodViewController)
        descriptionPage.text = UILabels.localizeWithoutComment(key: UILabels.DescriptionPageChoiceTypeFoodViewController)
        nextButton.setTitle(UILabels.localizeWithoutComment(key: UILabels.ValidateButton), for: .normal)
        
        self.typeFoodTableView.dataSource = self
        self.typeFoodTableView.delegate = self
        getTypeFood()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkEnabledNextbutton() {
        
        if listTypeFoodSelected.count == 0
        {
            nextButton.isHidden = true
        }
        else
        {
            nextButton.isHidden = false
        }
    }
    
    @IBAction func selectTypeFood(_ sender: UICheckbox) {
        
        if sender.isSelected
        {
            listTypeFoodSelected.append(listTypeFood[sender.tag])
        }
        else
        {
            let indexButton = listTypeFoodSelected.index(of: listTypeFood[sender.tag])
            listTypeFoodSelected.remove(at: indexButton!)
        }
        
        checkEnabledNextbutton()
    }
    
    fileprivate func getTypeFood()
    {
        self.listTypeFood = [String]()
        Database.database().reference().child("\(ModelDB.typeFood)/\(Service.LanguageApp)").queryOrderedByValue().observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                let listChildren = snapchot.children
                while let child = listChildren.nextObject() as? DataSnapshot
                {
                    self.listTypeFood.append(child.value as! String)
                }
                
                self.typeFoodTableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTypeFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = typeFoodTableView.dequeueReusableCell(withIdentifier: Service.ChoiceTypeFoodIdCell, for: indexPath) as! ChoiceTypeFoodTableViewCell
        cell.title?.text = listTypeFood[indexPath.item]
        cell.checkbox.tag = indexPath.item
        return cell
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
    
    @IBAction func nextPage() {
        
        let parent = parentPageViewController as! ChoiceUserPageViewController
        parent.typeFood = listTypeFoodSelected
        parentPageViewController.goToNextPage()
        parent.pageControl.currentPage = 2
    }
}
