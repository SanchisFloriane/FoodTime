//
//  ChoiceTypeDrinkViewController.swift
//  DrinkTime
//
//  Created by bob on 7/25/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase
import UICheckbox_Swift

class ChoiceTypeDrinkViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PageObservation {
   
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var descriptionPage: UILabel!
    @IBOutlet weak var typeDrinkTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    var parentPageViewController : UIPageViewController!
    var listTypeDrink: [String] = [String]()
    var listTypeDrinkSelected : [String] = [String]()
    
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
        
        titlePage.text = UILabels().localizeWithoutComment(key: UILabels().TitlePageChoiceTypeDrinkViewController)
        descriptionPage.text = UILabels().localizeWithoutComment(key: UILabels().DescriptionPageChoiceTypeDrinkViewController)
        
        self.typeDrinkTableView.dataSource = self
        self.typeDrinkTableView.delegate = self
        getTypeDrink()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkEnabledNextbutton() {
        
        if listTypeDrinkSelected.count == 0
        {
            nextButton.isHidden = true
        }
        else
        {
            nextButton.isHidden = false
        }
    }
    
    @IBAction func selectTypeDrink(_ sender: UICheckbox) {
        
        if sender.isSelected
        {
            listTypeDrinkSelected.append(listTypeDrink[sender.tag])
        }
        else
        {
            let indexButton = listTypeDrinkSelected.index(of: listTypeDrink[sender.tag])
            listTypeDrinkSelected.remove(at: indexButton!)
        }
        
        checkEnabledNextbutton()
    }
    
    fileprivate func getTypeDrink()
    {
        self.listTypeDrink = [String]()
        
        Database.database().reference().child("\(ModelDB.typeDrink)/\(Service.LanguageApp)").queryOrderedByValue().observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                let listChildren = snapchot.children
                while let child = listChildren.nextObject() as? DataSnapshot
                {
                    self.listTypeDrink.append(child.value as! String)
                }
                
                self.typeDrinkTableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTypeDrink.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = typeDrinkTableView.dequeueReusableCell(withIdentifier: Service.ChoiceTypeDrinkIdCell, for: indexPath) as! ChoiceTypeDrinkTableViewCell
        cell.title?.text = listTypeDrink[indexPath.item]
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
        parent.pageControl.currentPage = 1
    }
    
}
