//
//  ModifyTripViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 28/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase

class ModifyTripViewController: UIViewController {

   
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var nameTripLbl: UILabel!
    @IBOutlet weak var nameTripTxtField: UITextField!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var navigationBarPage: UINavigationItem!
    @IBOutlet weak var startDatepicker: UIDatePicker!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    var trip : Trip?
    let idUser = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.hideKeyboardWhenTappedAround()
        setupView()
    }
    
    fileprivate func setupView()
    {
        navigationBarPage.title = UILabels.localizeWithoutComment(key: UILabels.ModifyTrip)
        cancelButton.title = UILabels.localizeWithoutComment(key: UILabels.Cancel)
        updateButton.title = UILabels.localizeWithoutComment(key: UILabels.Update)
        deleteButton.setTitle(UILabels.localizeWithoutComment(key: UILabels.Delete), for: .normal)
        detailsLbl.text = UILabels.localizeWithoutComment(key: UILabels.Details)
        nameTripLbl.text = UILabels.localizeWithoutComment(key: UILabels.NameTrip)
        nameTripTxtField.text = self.trip?.name
        startDateLbl.text = UILabels.localizeWithoutComment(key: UILabels.StartDate)
        endDateLbl.text = UILabels.localizeWithoutComment(key: UILabels.StartDate)
        
        //Set dates
        startDatepicker.setDate(self.trip!.startDate!, animated: false)
        endDatePicker.setDate(self.trip!.endDate!, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func textFieldEditingDidChange() {
        
        if nameTripTxtField.text?.count == 0
        {
            updateButton.isEnabled = false
        }
        else
        {
            updateButton.isEnabled = true
        }
    }
    
    fileprivate func deleteTrip()
    {
        //Delete all places with idtrip
        for place in self.trip!.placeList
        {
            Database.database().reference().child("\(ModelDB.user_place)/\(idUser)").child("\(place.idPlace!)").removeValue { (error, ref) in
                
                if error != nil {
                    print("error \(String(describing: error))")
                }
            }
        }
        
        //Delete user trip
        Database.database().reference().child("\(ModelDB.user_trip)\(self.idUser)").observeSingleEvent(of: .value) { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                let listChildren = snapchot.children
                while let child = listChildren.nextObject() as? DataSnapshot
                {
                    let idTrip = child.value as? String
                    if idTrip == self.trip!.idTrip
                    {
                        child.setValue(nil, forKey: child.key)
                    }
                }
            }
        }
        
        //Delete trip
        Database.database().reference().child("\(ModelDB.trips)").child("\(self.trip!.idTrip)").removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
            else
            {
                
            }
        }
    }
    
    @IBAction func delete() {
    
        let alert = UIAlertController(title: UILabels.localizeWithoutComment(key: UILabels.TitleModifyTripViewController), message: UILabels.localizeWithoutComment(key: UILabels.DescriptionModifyTripViewController), preferredStyle: .alert)
        
        let yes = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.Yes), style: .default) { (action:UIAlertAction) in
            //Remove to a trip
            self.deleteTrip()
        }
        
        let no = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.No), style: .default)
        
        alert.addAction(yes)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func update(_ sender: UIBarButtonItem) {
        //Get data fro; view
        let nameTrip = nameTripTxtField.text
        let startDate = startDatepicker.date
        let endDate = endDatePicker.date
        self.trip = Trip(idTrip: self.trip?.idTrip, name: nameTrip, startDate: startDate, endDate: endDate)
        let valuesTrip : [String : String] = trip!.getData()
        
        //Save into trip DB
        Database.database().reference().child("\(ModelDB.trips)").child("\(self.trip!.idTrip!)").updateChildValues(valuesTrip) { (error, ref) in
            
                if error != nil
                {
                    print("\(UIMessages.ErrorTitle) : \(String(describing: error))")
                }
                else
                {
                    self.redirectionPageTrip()
                }
            }
    }
    
    func redirectionPageTrip()
    {
        UserTrip.loadUserTrip(completion: { (userTripList) in
            
            let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
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
}
