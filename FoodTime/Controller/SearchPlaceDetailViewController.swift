//
//  SearchPlaceDetailViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 01/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class SearchPlaceDetailViewController: UIViewController, UITabBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var filterListButton: UIBarButtonItem!
    @IBOutlet weak var newsButton: UITabBarItem!
    
    @IBOutlet weak var placesButton: UITabBarItem!
    @IBOutlet weak var profileButton: UITabBarItem!
    @IBOutlet weak var recommandationsButton: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tablePlaceView: UITableView!
    @IBOutlet weak var titlePage: UINavigationItem!
    
    //Localisation user
    let locationManager = CLLocationManager()
    var isUserLocalized : Bool = false
    
    //Configuration Google Place API
    var placesClient : GMSPlacesClient!
    var arrayLocation : [GMSAutocompletePrediction] = [GMSAutocompletePrediction]()
    var arrayPlace : [Place?] = [Place?]()
    
    var findPlaceLocation : Bool = false
    var isSearchPlaceBar : Bool = false
    var isSearchLocationBar : Bool = false
    
    lazy var filterPlace : GMSAutocompleteFilter = {
        let filterPlace = GMSAutocompleteFilter()
        filterPlace.type = .establishment
        return filterPlace
    }()
    
    lazy var filterLocation : GMSAutocompleteFilter = {
        let filterLocation = GMSAutocompleteFilter()
        filterLocation.type = .city
        return filterLocation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        
        self.tabBar.delegate = self
        
        //Ask user localization
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        setupView()
    }
    
    fileprivate func setupView()
    {
        self.localizeUser()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        titlePage.title = UILabels.localizeWithoutComment(key: UILabels.TitleSearchPlaceDetailViewController)
        
        newsButton.title = UILabels.localizeWithoutComment(key: UILabels.MyNewsButton)
        placesButton.title = UILabels.localizeWithoutComment(key: UILabels.MyPlacesButton)
        recommandationsButton.title = UILabels.localizeWithoutComment(key: UILabels.RecommandationsButton)
        profileButton.title = UILabels.localizeWithoutComment(key: UILabels.MyProfileButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        var desController : UIViewController!
        
        let item = tabBar.selectedItem
        if item == newsButton
        {
            desController = mainStoryboard.instantiateViewController(withIdentifier: Service.HomeViewController) as! HomeViewController
            
            self.navigationController?.pushViewController(desController, animated: true)
        }
        else if item == placesButton
        {
            
        }
        else if item == recommandationsButton
        {
            
        }
        else if item == profileButton
        {
            
        }
    }
    
}

extension SearchPlaceDetailViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tablePlaceView.dequeueReusableCell(withIdentifier: Service.SearchPlaceDetailIdCell) as! SearchPlaceDetailTableViewCell
        
       /* if isSearchPlaceBar
        {
            cell.namePlaceLbl.attributedText = NSAttributedString(string: (arrayPlace[indexPath.row]?.name)!)
            cell.addressPlaceLbl.attributedText = NSAttributedString(string: (arrayPlace[indexPath.row]?.formattedAddress)!)
            cell.placeId = (arrayPlace[indexPath.row]?.idPlace!)!
            cell.imageView?.image = UIImage(named: Service.FoodPlaceIcon)
            cell.isLocationCell = false
        }
        else
        {
            cell.namePlaceLbl.attributedText = arrayLocation[indexPath.row].attributedPrimaryText
            cell.addressPlaceLbl.attributedText = arrayLocation[indexPath.row].attributedSecondaryText
            cell.placeId = arrayLocation[indexPath.row].placeID!
            cell.imageView?.image = UIImage(named: Service.CityPlaceIcon)
            cell.isLocationCell = true
        }*/
        
      /*  if isUserLocalized {
            
            placesClient.lookUpPlaceID(cell.placeId, callback: { (place, error) -> Void in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                
                guard let place = place else {
                    print("No place details for \(cell.placeId)")
                    return
                }
                
                let coordinate₀ = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                let coordinate₁ = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                let distanceInMetric = distanceInMeters.conversionInUserMetric()
                
                cell.distancePlaceLbl.attributedText = NSAttributedString(string: distanceInMetric)
            })
        }
        else
        {
            cell.distancePlaceLbl.attributedText = NSAttributedString(string: "")
        }*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayPlace.count
    }

}
