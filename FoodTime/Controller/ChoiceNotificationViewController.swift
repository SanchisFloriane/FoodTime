//
//  ChoiceNotificationViewController.swift
//  FoodTime
//
//  Created by bob on 7/26/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase

class ChoiceNotificationViewController: UIViewController, PageObservation {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var descriptionPage: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    var parentPageViewController : UIPageViewController!
    var isNotified : Bool = false
    
    func getParentUIPageViewController(parentRef: UIPageViewController)
    {
        self.parentPageViewController = parentRef
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    fileprivate func setupView()
    {
        titlePage.text = UILabels.localizeWithoutComment(key: UILabels.TitlePageChoiceNotificationViewController)
        descriptionPage.text = UILabels.localizeWithoutComment(key: UILabels.DescriptionPageChoiceNotificationViewController)
        nextButton.setTitle(UILabels.localizeWithoutComment(key: UILabels.ActivateNotificationsButton), for: .normal)
        skipButton.setTitle(UILabels.localizeWithoutComment(key: UILabels.SkipButton), for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func backPage() {
        let parent = parentPageViewController as! ChoiceUserPageViewController
        parentPageViewController.goToPreviousPage()
        parent.pageControl.currentPage = 2
    }
    
    @IBAction func nextPage(_ sender: UIButton) {
        
        if sender.isEqual(nextButton)
        {
            isNotified = true
        }
        
        saveUserSettings()
        saveUserTastes()
        
        self.dismiss(animated: true, completion: nil)
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : UIViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.HomeViewController) as! HomeViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    
    fileprivate func saveUserSettings() {
        
        let settings = Settings(isNotified: self.isNotified.description, homeCountry: nil, homeState: nil, homeAddress: nil, homeCity: nil, homeZipCode: nil, workCountry: nil, workState: nil, workAddress: nil, workCity: nil, workZipCode: nil)
        
        let uid = Auth.auth().currentUser?.uid
        let values : [String : [String: String?]]! = [uid! : settings.getData()]
        
        Database.database().reference().child("\(ModelDB.settings)").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to save user settings with error: \(err)")
                return
            }
            print("Successfully saved isnotified info into Firebase database")
        })
    }
    
    fileprivate func saveUserTastes() {
        
        let parent = parentPageViewController as! ChoiceUserPageViewController
        let tastes = Tastes(typeDrinkPlace: parent.typeDrinkPlace, typeFoodPlace: parent.typeFoodPlace, typeDrink: parent.typeDrink, typeFood: parent.typeFood)
        
        let uid = Auth.auth().currentUser?.uid
        let values = [uid! : tastes.getData()]
        
        Database.database().reference().child("\(ModelDB.tastes)").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to save user tastes with error: \(err)")
                return
            }
            print("Successfully saved tastes info into Firebase database")
        })
    }
    
}
