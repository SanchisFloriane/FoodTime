//
//  ChoicePlaceViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 19/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit

class ChoicePlaceViewController: UIViewController, PageObservation {
    
    var parentPageViewController : UIPageViewController!
    
    func getParentUIPageViewController(parentRef: UIPageViewController)
    {
        parentPageViewController = parentRef
    }
    
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var descriptionPage: UILabel!
    
    @IBOutlet weak var barButton: UIButton!
    @IBOutlet weak var coffeeButton: UIButton!
    @IBOutlet weak var fastFoodButton: UIButton!
    @IBOutlet weak var foodTruckButton: UIButton!
    @IBOutlet weak var restaurantButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var placeSelected : [UIButton] = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView()
    {
        nextButton.isHidden = true
        
        titlePage.text = UILabels().localizeWithoutComment(key: UILabels().TitlePageChoiceTypePlaceViewController)
        descriptionPage.text = UILabels().localizeWithoutComment(key: UILabels().DescriptionPageChoiceTypePlaceViewController)
        nextButton.setTitle(UILabels().localizeWithoutComment(key: UILabels().ValidateButton), for: .normal)
        
        barButton.tag = 0
        coffeeButton.tag = 1
        fastFoodButton.tag = 2
        foodTruckButton.tag = 3
        restaurantButton.tag = 4
        
        if parentPageViewController != nil
        {
            for view in parentPageViewController.view.subviews
            {
                if let subview = view as? UIScrollView
                {
                    subview.isScrollEnabled = false
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectPlace(_ sender: UIButton) {
        
        if sender != nextButton
        {
            if sender.layer.borderColor != UIColor.green.cgColor
            {
                sender.layer.borderWidth = 5
                sender.layer.borderColor = UIColor.green.cgColor
                placeSelected.append(sender)
            }
            else
            {
                sender.layer.borderWidth = 0
                sender.layer.borderColor = nil
                let indexButton = placeSelected.index(of: sender)
                placeSelected.remove(at: indexButton!)
            }
            
            checkEnabledContinuebutton()
        }
    }
    
    func checkEnabledContinuebutton() {
        
        if placeSelected.count == 0
        {
            nextButton.isHidden = true
        }
        else
        {
            nextButton.isHidden = false
        }
    }

    @IBAction func nextPage() {
        
        var typePlaceTab : [Int] = [Int]()
        for buttonPlace in placeSelected
        {
            let typePlace : TypePlace? = TypePlace.toEnum(idEnum: buttonPlace.tag)
            if typePlace != nil
            {
                typePlaceTab.append(typePlace!.rawValue)
            }
        }
        
        let parent = parentPageViewController as! ChoiceUserPageViewController
        parent.typePlace = typePlaceTab
        print(parent.typePlace)
        parentPageViewController.goToNextPage()
        parent.pageControl.currentPage = 1
    }
    
}
