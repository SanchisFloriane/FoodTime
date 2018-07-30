//
//  ChoicePlaceViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 19/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase

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
    var listTypePlace : [Int: String] = [Int: String]()
    
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
        
        getTypePlace()
        
        barButton.tag = TypePlace.TypePlaceDrink.Bar.rawValue
        coffeeButton.tag = TypePlace.TypePlaceDrink.Coffee.rawValue
        fastFoodButton.tag = TypePlace.TypePlaceFood.FastFood.rawValue
        foodTruckButton.tag = TypePlace.TypePlaceFood.FoodTruck.rawValue
        restaurantButton.tag = TypePlace.TypePlaceFood.Restaurant.rawValue
        
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
    
    fileprivate func getTypePlace()
    {
        self.listTypePlace = [Int: String]()
        Database.database().reference().child("\(ModelDB.typePlace)/\(Service.LanguageApp)").queryOrderedByValue().observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                let listChildren = snapchot.children
                while let child = listChildren.nextObject() as? DataSnapshot
                {
                    self.listTypePlace[Int(child.key)!] = child.value as? String
                }
            }
        })
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
        
        var typeFoodPlace : [String] = [String]()
        var typeDrinkPlace : [String] = [String]()
        
        for buttonPlace in placeSelected
        {
            for typePlace in listTypePlace
            {
                
                if typePlace.key ==  buttonPlace.tag
                {
                    if TypePlace.getTypePlace(typePlace: typePlace.key) == TypePlace.typeDrinkPlace
                    {
                        typeDrinkPlace.append(typePlace.value)
                    }
                    else
                    {
                        typeFoodPlace.append(typePlace.value)
                    }
                }
            }
        }
        let parent = parentPageViewController as! ChoiceUserPageViewController
        parent.typeFoodPlace = typeFoodPlace
        parent.typeDrinkPlace = typeDrinkPlace
        parentPageViewController.goToNextPage()
        parent.pageControl.currentPage = 1
    }
    
}
