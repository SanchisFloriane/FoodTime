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
        self.mapView.clear()
        
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
            
            if !(self.place.phoneNumber?.isEmpty)!
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
            
            /*     if self.place.latLocation != nil && self.place.lngLocation != nil
             {
             let coordinates = CLLocationCoordinate2DMake(self.place.latLocation!, self.place.lngLocation!)
             let marker = GMSMarker(position: coordinates)
             marker.title = self.place.name
             marker.map = self.mapView
             self.mapView.animate(toLocation: coordinates)
             }*/
            
            if self.place.openNow != nil && self.place.openNow!
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
            
            if !(self.place.rating?.isEmpty)!
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
