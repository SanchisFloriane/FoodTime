//
//  CreateTripViewController.swift
//  FoodTime
//
//  Created by bob on 8/20/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase

class CreateTripViewController: UIViewController {

    @IBOutlet weak var CancelBarBtn: UIBarButtonItem!
    @IBOutlet weak var DetailsLbl: UILabel!
    @IBOutlet weak var EndDatePicker: UIDatePicker!
    @IBOutlet weak var EndDateLbl: UILabel!
    @IBOutlet weak var NavigationBarCreateTrip: UINavigationItem!
    @IBOutlet weak var SaveBarBtn: UIBarButtonItem!
    @IBOutlet weak var StartDatePicker: UIDatePicker!
    @IBOutlet weak var StartDateLbl: UILabel!
    @IBOutlet weak var TripNameTxtField: UITextField!
    @IBOutlet weak var TripNameLbl: UILabel!
    
    
    let idUser = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    fileprivate func setupView()
    {        
        NavigationBarCreateTrip.title = UILabels.localizeWithoutComment(key: UILabels.CreateATrip)
        CancelBarBtn.title = UILabels.localizeWithoutComment(key: UILabels.Cancel)
        SaveBarBtn.title = UILabels.localizeWithoutComment(key: UILabels.Save)
        DetailsLbl.text = UILabels.localizeWithoutComment(key: UILabels.Details)
        TripNameLbl.text = UILabels.localizeWithoutComment(key: UILabels.NameTrip)
        TripNameTxtField.placeholder = UILabels.localizeWithoutComment(key: UILabels.EnterAName)
        TripNameTxtField.text = ""
        StartDateLbl.text = UILabels.localizeWithoutComment(key: UILabels.StartDate)
        EndDateLbl.text = UILabels.localizeWithoutComment(key: UILabels.StartDate)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        //Get data fro; view
        let nameTrip = TripNameTxtField.text
        let startDate = StartDatePicker.date
        let endDate = EndDatePicker.date
        let trip = Trip(idTrip: nil, name: nameTrip, startDate: startDate, endDate: endDate)
        let values : [String : String] = trip.getData()
        
        //Save into trip DB
        let refTrip = Database.database().reference().child("\(ModelDB.trips)").childByAutoId()
        refTrip.setValue(values)
        let idTrip = refTrip.key
        
        //Save into user trip DB
       /* let refUserTrip = Database.database().reference().child("\(ModelDB.user_trip)").childByAutoId()
        let values : [String : String] = [self.idUser : idTrip]
        refUserTrip.setValue(values)*/
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : UIViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.MyListTripsViewController) as! MyListTripsViewController
        self.navigationController?.pushViewController(desController, animated: false)
    }
}
