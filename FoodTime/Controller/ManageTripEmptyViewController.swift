//
//  ManageTripEmpt/Users/florianesanchis/Documents/FoodTime/FoodTime/New Group1/Base.lproj/Main.storyboardyViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 27/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase

class ManageTripEmptyViewController: UIViewController {


    @IBOutlet weak var addTripButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var manageButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBarPage: UINavigationItem!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var descriptionPageTxtView: UITextView!
    
    var trip : Trip?
    var idUser = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        getPlaceFromTrip(idTrip: trip!.idTrip!, completion: { (placeListFromTrip) in
            self.trip?.placeList = placeListFromTrip
            
            if self.trip!.placeList.count > 0
            {
                let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
                let desController : ManageTripViewController = mainStoryboard.instantiateViewController(withIdentifier: Service.ManageTripViewController) as! ManageTripViewController
                desController.trip = self.trip
                self.navigationController?.pushViewController(desController, animated: true)
            }
        })
    }
    
    
    
    func getPlaceFromTrip(idTrip: String, completion:@escaping ([Place])->())
    {
        var placeFromTripList : [Place] = [Place]()
        
        //Get all trips of the current user for the place selected
        Database.database().reference().child("\(ModelDB.user_place)/\(self.idUser!)").observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                let listChildren = snapchot.children
                while let child = listChildren.nextObject() as? DataSnapshot
                {
                    let idPlace = child.key
                    let listTrips = child.value as? [String : String]
                    for tripPlace in listTrips!
                    {
                        if idTrip == tripPlace.key
                        {
                            placeFromTripList.append(Place(idPlace: idPlace))
                        }
                    }
                }
                completion(placeFromTripList)
            }
            else
            {
                completion(placeFromTripList)
            }
        })
    }
    
    fileprivate func setupView()
    {
        mapButton.isEnabled = false
        self.addTripButton.titleLabel?.text = UILabels.localizeWithoutComment(key: UILabels.AddTrip)
        self.mapButton.titleLabel?.text = UILabels.localizeWithoutComment(key: UILabels.Map)
        self.navigationBarPage.title = UILabels.localizeWithoutComment(key: UILabels.ManageMyTrip)
        self.descriptionPageTxtView.text = UILabels.localizeWithoutComment(key: UILabels.DescriptionPageManageTripEmptyViewController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        
        UserTrip.loadUserTrip(completion: { (userTripList) in
            
            if !(userTripList.isEmpty)
            {
                let desController : MyListTripsViewController = mainStoryboard.instantiateViewController(withIdentifier: Service.MyListTripsViewController) as! MyListTripsViewController
                desController.userTripList = userTripList
                self.navigationController?.pushViewController(desController, animated: true)
            }
            else
            {
                let desController : MyEmptyTripsViewController = mainStoryboard.instantiateViewController(withIdentifier: Service.MyEmptyTripsViewController) as! MyEmptyTripsViewController
                self.navigationController?.pushViewController(desController, animated: true)
            }
            
        })
    }
    
    @IBAction func manageTrip(_ sender: UIBarButtonItem) {
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : ModifyTripViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.ModifyTripViewController) as! ModifyTripViewController
        desController.trip = self.trip
        self.navigationController?.pushViewController(desController, animated: true)
    }
    
}
