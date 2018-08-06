//
//  SearchPlaceViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 31/07/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class SearchPlaceViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchPlaceBar: UISearchBar!
    @IBOutlet weak var searchLocationBar: UISearchBar!
    @IBOutlet weak var tableViewPlace: UITableView!
    
    //Localisation user
    let locationManager = CLLocationManager()
    var isUserLocalized : Bool = false
    
    var placesClient : GMSPlacesClient!
    var arrayAddress : [GMSAutocompletePrediction] = [GMSAutocompletePrediction]()
    
    lazy var filter : GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.establishment
        return filter
    }()
    
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
    }
    
    func loadUI()
    {
        tableViewPlace.tableFooterView = UIView()
    }
    
    fileprivate func setupView()
    {
        searchPlaceBar.delegate = self
        searchLocationBar.delegate = self
        
        searchPlaceBar.placeholder = UILabels.localizeWithoutComment(key: UILabels.SearchPlaceBarPlaceHolder)
        searchLocationBar.placeholder = UILabels.localizeWithoutComment(key: UILabels.SearchLocationBarPlaceHolder)
        
        loadUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchPlaceViewController: UITableViewDelegate, UITableViewDataSource
{
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewPlace.dequeueReusableCell(withIdentifier: Service.SearchPlaceIdCell) as! SearchPlaceTableViewCell
        cell.namePlaceLbl.attributedText = arrayAddress[indexPath.row].attributedPrimaryText
        cell.addressPlaceLbl.attributedText = arrayAddress[indexPath.row].attributedSecondaryText
        cell.placeId = arrayAddress[indexPath.row].placeID!
        cell.imageView?.image = UIImage(named: Service.FoodPlaceIcon)
        
        if isUserLocalized {
            
            placesClient.lookUpPlaceID(cell.placeId, callback: { (place, error) -> Void in
                if let error = error {
                    print("lookup place id query error: \(error.localizedDescription)")
                    return
                }
                
                guard let place = place else {
                    print("No place details for \(cell.placeId)")
                    return
                }
                
                let coordinate₀ = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
                let coordinate₁ = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                
                let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                let distanceInMetric = distanceInMeters.conversionInUserMetric()
                
                cell.distancePlaceLbl.attributedText = NSAttributedString(string: distanceInMetric)
            })
        } else {
            cell.distancePlaceLbl.attributedText = NSAttributedString(string: "")
        }
        
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("location error is = \(error.localizedDescription)")
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        print("Current Locations = \(locValue.latitude) \(locValue.longitude)")
    }
}

extension SearchPlaceViewController: UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !(searchLocationBar.text?.isEmpty)! && !(searchPlaceBar.text?.isEmpty)!
        {
            let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
            let desController : UIViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.SearchPlaceDetailViewController) as! SearchPlaceDetailViewController
            
            desController.hidesBottomBarWhenPushed=false
            self.navigationController?.pushViewController(desController, animated: true)
            
        }
        else if (searchPlaceBar.text?.isEmpty)!
        {
            Service.showAlert(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.ErrorTitle), message: UIMessages.localizeWithoutComment(key: UIMessages.ErrorEnterPlace))
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (searchBar.text?.isEmpty)!
        {
            self.arrayAddress = [GMSAutocompletePrediction]()
        }
        else
        {
            let searchStr = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
            
            if searchStr == ""
            {
                self.arrayAddress = [GMSAutocompletePrediction]()
            }
            else
            {
                GMSPlacesClient.shared().autocompleteQuery(searchStr, bounds: nil, filter: filter, callback: { (result, error) in
                    
                    if error == nil && result != nil
                    {
                        self.arrayAddress = result!
                        print(result!)
                    }
                })
            }
        }
        self.tableViewPlace.reloadData()
        return true
    }
}
