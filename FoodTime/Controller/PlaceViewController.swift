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
import GooglePlacePicker
import iCarousel
import Cosmos
import Firebase

class PlaceViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate, iCarouselDelegate, iCarouselDataSource {
    
    @IBOutlet weak var addressPlaceLbl: UILabel!
    @IBOutlet weak var bookButton: UIBarButtonItem!
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    var mapView: GMSMapView!
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var namePlaceLbl: UILabel!
    @IBOutlet weak var openingHoursButton: UIButton!
    @IBOutlet weak var openingHoursLbl: UILabel!
    @IBOutlet weak var placeInformationLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var priceImageView: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var websiteTxtView: UITextView!    
    
    let idUser = Auth.auth().currentUser!.uid
    
    //Taste user
    var isLikedPlace : Bool = false
    var isBookedPlace : Bool = false
    
    //Localisation user
    var locationManager: CLLocationManager = CLLocationManager()
    var isUserLocalized : Bool = false
    
    var place : Place = Place()
    var placePicker: GMSPlacePickerViewController!
    var latitude: Double!
    var longitude: Double!
    
    //Configuration Google Place API
    var placesClient : GMSPlacesClient!
    
    //Carousel
    var indexLastSubViewCarousel : Int?
    var tabPhotos : [UIImage?] = [UIImage?]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        
        setupView()
        
        //Ask user localization
        self.mapView.clear()
        self.localizeUser()
        
        loadPlace()
    }
    
    fileprivate func setupView()
    {
        self.mapView = GMSMapView(frame: self.mapViewContainer.frame)
        self.mapView.animate(toZoom: 18.0)
        self.mapView.isMyLocationEnabled = true
        self.view.addSubview(self.mapView)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        placeInformationLbl.text = UILabels.localizeWithoutComment(key: UILabels.PlaceInformationTitle)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        carouselView.type = .linear
        
        shareButton.isEnabled = false
        
        // Do not change rating when touched
        // Use if you need just to show the stars without getting user's input
        self.ratingView.settings.updateOnTouch = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mapView = GMSMapView(frame: self.mapViewContainer.frame)
        self.mapView.animate(toZoom: 18.0)
        self.view.addSubview(self.mapView)
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
            Place.jsonToPlace(tab: json, requestPhoto: true, completion: { (placeConverted) in
                self.place = placeConverted
            })
            self.loadData()
        })
    }
    
    func loadData()
    {
        DispatchQueue.main.async(execute: {
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
            
            if self.place.phoneNumber != nil
            {
                self.phoneNumberLbl.text = self.place.phoneNumber
            }
            else
            {
                self.websiteTxtView.text = UILabels.localizeWithoutComment(key: UILabels.NoPhoneNumber)
            }
            
            self.addressPlaceLbl.text = self.place.formattedAddress
            
            if self.isUserLocalized
            {
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
            
            if self.place.latLocation != nil && self.place.lngLocation != nil
            {
                let coordinates = CLLocationCoordinate2DMake(self.place.latLocation!, self.place.lngLocation!)
                let marker = GMSMarker(position: coordinates)
                marker.title = self.place.name
                marker.map = self.mapView
                self.mapView.animate(toLocation: coordinates)
            }
            
            if self.place.openNow != nil && self.place.openNow!
            {
                self.openingHoursLbl.text = UILabels.localizeWithoutComment(key: UILabels.PlaceOpenNow)
                self.openingHoursButton.isHidden = false
            }
            else
            {
                self.openingHoursLbl.text = UILabels.localizeWithoutComment(key: UILabels.PlaceClosedNow)
                self.openingHoursButton.isHidden = true
            }
            
            if self.place.priceLevel != nil
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
            
            if self.place.rating != nil
            {
                self.ratingView.rating = Double(self.place.rating!)!
            }
            
            self.loadFirstPhotoForPlace(placeID: self.place.idPlace!)
        })
    }
    
    @IBAction func sharePlace(_ sender: UIBarButtonItem) {
        //to do
    }
    
    @IBAction func bookPlace(_ sender: UIBarButtonItem) {
        
        if isBookedPlace
        {
            bookButton.image = UIImage(named: Service.BookmarkEmptyIcon)
        }
        else
        {
            bookButton.image = UIImage(named: Service.BookmarkFullEmptyIcon)
        }
        
        isBookedPlace = !isBookedPlace
        
        if isBookedPlace
        {
            //Save in DB
            self.showAlertSaveYesNo(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.SaveToATripAlertTitle), message: UIMessages.localizeWithoutComment(key: UIMessages.SaveToATripAlertText))
        }
    }
    
    @IBAction func likePlace(_ sender: UIBarButtonItem) {
        
        if isLikedPlace
        {
            likeButton.image = UIImage(named: Service.LikeEmptyIcon)
        }
        else
        {
            likeButton.image = UIImage(named: Service.LikeFullIcon)
        }
        
        isLikedPlace = !isLikedPlace
        
        if isLikedPlace
        {
            //Save in DB
            self.showAlertSaveYesNo(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.SaveToATripAlertTitle), message: UIMessages.localizeWithoutComment(key: UIMessages.SaveToATripAlertText))
        }
        else
        {
            self.showAlertRemoveYesNo(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.RemoveToATripOrPlaceAlertTitle))
        }
    }
    
    
    func showAlertRemoveYesNo(on: UIViewController, style: UIAlertControllerStyle, title: String?, completion: (() -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: style)
        
        let removeToATripAction = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.RemoveToATrip), style: .default) { (action:UIAlertAction) in
            //Remove to a trip
            print("You've press to remove a place to a trip");
            //self.showAlertRemoveTripUserList(on: self, style: .actionSheet, title: UIMessages.localizeWithoutComment(key: UIMessages.RemoveToATripAlertTitle))
        }
        
        let removeAPlaceAction = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.RemoveAPlace), style: .default) { (action:UIAlertAction) in
            //Remove to a place
            print("You've press to remove the place of the favourite user places")
            self.removePlaceUser()
        }
        
        
        let cancel = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.Cancel), style: .cancel)  { (action:UIAlertAction) in
            //cancel action
            self.likePlace(self.likeButton)
        }
        
        alert.addAction(removeToATripAction)
        alert.addAction(removeAPlaceAction)
        alert.addAction(cancel)
        
        on.present(alert, animated: true, completion: completion)
    }
    
    func showAlertSaveYesNo(on: UIViewController, style: UIAlertControllerStyle, title: String?, message: String?, completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let yesAction = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.Yes), style: .default) { (action:UIAlertAction) in
            //Save to a trip
            print("You've press to save to a trip");
            self.showAlertTripUserList(on: self, style: .actionSheet, title: UIMessages.localizeWithoutComment(key: UIMessages.SaveToATripAlertTitle), message: "")
        }
        
        let noAction = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.No), style: .default) { (action:UIAlertAction) in
            //Save to a trip
            print("You've press to save to a favourite places list");
            //Save the place without trip in DB
            self.savePlaceUser()
        }
        
        
        let cancel = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.Cancel), style: .cancel)  { (action:UIAlertAction) in
            //cancel action
            self.likePlace(self.likeButton)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        alert.addAction(cancel)
        
        on.present(alert, animated: true, completion: completion)
    }
    
    func loadUserTrip(completion:@escaping ([UserTrip])->())
    {
        var userTripList : [UserTrip] = [UserTrip]()
        
        //Get all trips of the current user
        Database.database().reference().child("\(ModelDB.user_trip)/\(idUser)").observeSingleEvent(of: .value, with: { (snapchot) in
            
            if snapchot.childrenCount > 0
            {
                let listChildren = snapchot.children
                while let child = listChildren.nextObject() as? DataSnapshot
                {
                    let idTrip = child.value as? String
                    userTripList.append(UserTrip(idUser: self.idUser, idTrip: idTrip!))
                }
                
                completion(userTripList)
            }
            else
            {
                completion(userTripList)
            }
        })
    }
    
    func loadTrip(userTripList: [UserTrip], completion:@escaping ([Trip])->())
    {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = Service.formatterDate
        
        var tripList : [Trip] = [Trip]()
        var index = 0
        for userTrip in userTripList
        {
            Database.database().reference().child("\(ModelDB.trips)/\(userTrip.idTrip!)").queryOrdered(byChild: ModelDB.Trip_name).observeSingleEvent(of: .value, with: { (snapchot) in
                
                if snapchot.childrenCount > 0
                {
                    let listChildren = snapchot.children
                    var name : String?
                    var startDate : Date?
                    var endDate : Date?
                    
                    while let child = listChildren.nextObject() as? DataSnapshot
                    {
                        if child.key == ModelDB.Trip_name
                        {
                            name = child.value as? String
                        }
                        
                        if child.key == ModelDB.Trip_startDate
                        {
                            let date = child.value as? String
                            if date != nil && !date!.isEmpty
                            {
                                startDate = formatter.date(from: date!)
                            }
                        }
                        
                        if child.key == ModelDB.Trip_endDate
                        {
                            let date = child.value as? String
                            if date != nil && !date!.isEmpty
                            {
                                endDate = formatter.date(from: date!)
                            }
                        }
                    }
                    tripList.append(Trip(idTrip: userTrip.idTrip, name: name, startDate: startDate, endDate: endDate))
                    index += 1
                }
                else
                {                    
                    completion(tripList)
                }
                
                if index == userTripList.count
                {
                    completion(tripList)
                }
            })
        }
    }
    
    func savePlaceUser() {
        
        //Save in user_place DB
        let idPlace = self.place.idPlace
        let isLiked = self.isLikedPlace
        let toTest = false
        let userPlace = UserPlace(idUser: self.idUser, idPlace: idPlace, idTrip: nil, isLiked: isLiked, toTest: toTest)
        let values : [String: [String: String]] = [userPlace.idPlace! : userPlace.getData()]
        Database.database().reference().child("\(ModelDB.user_place)/\(self.idUser)").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to save user info with error: \(err)")
                return
            }
            print("Successfully saved user place into Firebase database")
        })
        
    }
    
    func removePlaceUser() {
        
        //Save in user_place DB
        let idPlace = self.place.idPlace!
        Database.database().reference().child("\(ModelDB.user_place)/\(self.idUser)/\(idPlace)").removeValue() { (err, ref) in
            if let err = err {
                print("Failed to remove user place info with error: \(err)")
                return
            }
            print("Successfully removed user place into Firebase database")
        }
    }
    
    func showAlertTripUserList(on: UIViewController, style: UIAlertControllerStyle, title: String?, message: String?, completion: (() -> Swift.Void)? = nil) {
        
        //Get all trip of the user in DB
        self.loadUserTrip { (userTripList) in
            
            //Get all name trips of the current user
            if !(userTripList.isEmpty)
            {
                self.loadTrip(userTripList: userTripList, completion: { (tripList) in
                    
                    let alert = UIAlertController(title: title, message: message, preferredStyle: style)
                    
                    for trip in tripList
                    {
                        alert.addAction(UIAlertAction(title: trip.name, style: .default, handler: { (action) in
                            
                            //Save in user_place DB
                            let idTrip = trip.idTrip
                            let idPlace = self.place.idPlace
                            let isLiked = self.isLikedPlace
                            let toTest = false
                            let userPlace = UserPlace(idUser: self.idUser, idPlace: idPlace, idTrip: idTrip, isLiked: isLiked, toTest: toTest)
                            // let values : [String : [String : [String: String]]] = [self.idUser : [userPlace.idPlace! : userPlace.getData()]]
                            let values : [String: [String: String]] = [idTrip! : userPlace.getData()]
                            Database.database().reference().child("\(ModelDB.user_place)/\(self.idUser)/\(userPlace.idPlace!)").updateChildValues(values, withCompletionBlock: { (err, ref) in
                                if let err = err {
                                    print("Failed to save user info with error: \(err)")
                                    return
                                }
                                print("Successfully saved user place in trip into into Firebase database")
                            })
                        }))
                    }
                    let createTrip = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.CreateANewTrip), style: .default) { (action:UIAlertAction) in
                        //Change view controller to create trip view controller
                        print("You've press to create a trip");
                        /* self.dismiss(animated: true, completion: nil)
                         
                         let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
                         let desController : UIViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.CreateTripViewController) as! CreateTripViewController
                         self.navigationController?.pushViewController(desController, animated: false)*/
                    }
                    
                    let cancel = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.Cancel), style: .cancel){ (action:UIAlertAction) in
                        //cancel action
                        self.likePlace(self.likeButton)
                    }
                    
                    alert.addAction(createTrip)
                    alert.addAction(cancel)
                    
                    on.present(alert, animated: true, completion: completion)
                })
            }
        }
    }
    
    @IBAction func showOpeningHours() {
        
        var textHours : String = ""
        
        var i = 0
        for day in place.openingHours
        {
            textHours += "\(day ?? "")"
            if i < place.openingHours.count
            {
                textHours += "\n"
            }
            i += 1
        }
        Service.showAlert(on: self, style: .alert, title: UILabels.localizeWithoutComment(key: UIMessages.HoursTitle), message: textHours)
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
                
                //Picker for user location
                let coordinates = CLLocationCoordinate2DMake(locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude)
                let marker = GMSMarker(position: coordinates)
                marker.map = self.mapView
                self.mapView.animate(toLocation: coordinates)
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Number of image in the carousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        return tabPhotos.count
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        //Define the space between UIImage
        if option == iCarouselOption.spacing
        {
            return value
        }
        
        return value
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: carouselView.frame.width, height: carouselView.frame.height))
        tempView.backgroundColor = view?.backgroundColor
        let button = UIButton(frame: tempView.frame)
        let img = tabPhotos[index]
        button.setImage(img, for: .normal)
        tempView.addSubview(button)
        return tempView
    }
    
    func loadFirstPhotoForPlace(placeID: String)
    {
        placesClient.lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else if photos?.results != nil && !(photos?.results.isEmpty)!
            {
                var tabMetaData : [GMSPlacePhotoMetadata] = [GMSPlacePhotoMetadata]()
                for photo in (photos?.results)! {
                    tabMetaData.append(photo)
                }
                
                self.loadImageForMetadata(tabPhotoMetadata: tabMetaData, completion: {
                    self.carouselView.reloadData()
                })
            }
        }
    }
    
    func loadImageForMetadata(tabPhotoMetadata: [GMSPlacePhotoMetadata], completion:@escaping ()->()) {
        var index : Int = 0
        for photoMetadata in tabPhotoMetadata
        {
            self.placesClient.loadPlacePhoto(photoMetadata, callback: {
                (photo, error) -> Void in
                if let error = error {
                    // TODO: handle the error.
                    print("Error: \(error.localizedDescription)")
                } else {
                    self.tabPhotos.append(photo)
                    index += 1
                }
                
                if index == tabPhotoMetadata.count
                {
                    completion()
                }
            })
        }
    }
    
    //Get the UIImage selected
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
        indexLastSubViewCarousel = carousel.currentItemIndex
    }
}
