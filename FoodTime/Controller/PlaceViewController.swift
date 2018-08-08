//
//  PlaceViewController.swift
//  FoodTime
//
//  Created by bob on 8/7/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps

class PlaceViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate  {

    @IBOutlet weak var addressPlaceLbl: UILabel!
    @IBOutlet weak var bookButton: UIBarButtonItem!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    @IBOutlet weak var mapPlace: MKMapView!
    @IBOutlet weak var namePlaceLbl: UILabel!
    @IBOutlet weak var openingHoursButton: UIButton!
    @IBOutlet weak var openingHoursLbl: UILabel!
    @IBOutlet weak var placeInformationLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var priceImageView: UIImageView!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var websiteTxtView: UITextView!    
    
    var place : Place = Place()
    
    //Localisation user
    let locationManager = CLLocationManager()
    var isUserLocalized : Bool = false
    
    //Configuration Google Place API
    var placesClient : GMSPlacesClient!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        
        //Ask user localization
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.localizeUser()
        
        setupView()
        loadPlace()
    }
    
    fileprivate func setupView()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        placeInformationLbl.text = UILabels.localizeWithoutComment(key: UILabels.PlaceInformationTitle)
    }

    func loadPlace()
    {
        let idPlace : String = "&placeid=\(place.idPlace!)"
        let APIKey : String = "&key=\(Service.AraGooglePlaceAPIKey)"
        let language : String = "&language=\(Locale.current.languageCode!)"
        var url = "https://maps.googleapis.com/maps/api/place/details/json?"
        let query = ("\(idPlace)\(APIKey)\(language)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        url.append("\(query!)")
        GoogleServices.performGoogleQuery(url: URL(string: url)!, completion: { (json) in
            Place.jsonToPlace(tab: json, requestPhoto: true, onePlace: true, completion: { (placeConverted) in
                self.place = placeConverted[0]
                self.loadData()
            })
        })
    }
    
    func loadData()
    {
        self.namePlaceLbl.text = self.place.name
        if !(self.place.website?.isEmpty)!
        {
            // Setting the attributes
            let linkAttributes = [
                NSAttributedStringKey.link: URL(string: self.place.website!) ?? ""
                ] as [NSAttributedStringKey : Any]
            
            let attributedString = NSMutableAttributedString(string: UILabels.localizeWithoutComment(key: UILabels.VisitWebsiteLink))
            
            // Set the 'click here' substring to be the link
            attributedString.setAttributes(linkAttributes, range: NSMakeRange(0, attributedString.length))
            
            self.websiteTxtView.delegate = self
            self.websiteTxtView.attributedText = attributedString
        }
        else
        {
            self.websiteTxtView.text = UILabels.localizeWithoutComment(key: UILabels.NoWebsite)
        }
        
        if !(self.place.phoneNumber?.isEmpty)!
        {
            self.phoneNumberLbl.text = self.place.phoneNumber
        }
        else
        {
            self.websiteTxtView.text = UILabels.localizeWithoutComment(key: UILabels.NoPhoneNumber)
        }
        
        self.addressPlaceLbl.text = self.place.formattedAddress
        
        if self.isUserLocalized {
            
            self.placesClient.lookUpPlaceID(self.place.idPlace!, callback: { (placeFound, error) -> Void in
                
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                
                guard let placeFound = placeFound else {
                    print("No place details for \(self.place.idPlace!)")
                    return
                }
                
                let coordinate₀ = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                let coordinate₁ = CLLocation(latitude: placeFound.coordinate.latitude, longitude: placeFound.coordinate.longitude)
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                let distanceInMetric = distanceInMeters.conversionInUserMetric()
                
                self.distanceLbl.text = distanceInMetric
            })
        }
        else
        {
            self.distanceLbl.text = ""
        }
        
        if self.place.openNow
        {
            self.openingHoursLbl.text = UILabels.localizeWithoutComment(key: UILabels.PlaceOpenNow)
        }
        else
        {
            self.openingHoursLbl.text = UILabels.localizeWithoutComment(key: UILabels.PlaceClosedNow)
        }
        
        if !(self.place.priceLevel?.isEmpty)!
        {
            if self.place.priceLevel == "1"
            {
                self.priceImageView.image = UIImage(named: Service.PriceLevelOne)
            }
            else if self.place.priceLevel == "2"
            {
                self.priceImageView.image = UIImage(named: Service.PriceLevelTwo)
            }
            else if self.place.priceLevel == "3"
            {
                self.priceImageView.image = UIImage(named: Service.PriceLevelThree)
            }
        }
    }
    
    @IBAction func sharePlace(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func bookPlace(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func likePlace(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func showOpeningHours() {
        
        var textHours : String = ""
        
        var i = 0
        for day in place.openingHours
        {
            textHours += "\(String(describing: day))"
            if i < place.openingHours.count
            {
               textHours += "\n"
            }
            i += 1
        }
        Service.showAlert(on: self, style: .alert, title: UIMessages.HoursTitle, message: textHours)
    }
    
    func localizeUser()
    {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                isUserLocalized = false
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                isUserLocalized = true
            }
        }
        else
        {
            isUserLocalized = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("location error is = \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        print("Current Locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
