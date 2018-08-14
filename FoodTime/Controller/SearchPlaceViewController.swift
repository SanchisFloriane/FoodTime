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
        
        //Ask user localization
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.localizeUser()
        setupView()
    }
    
    fileprivate func setupView()
    {
        searchPlaceBar.delegate = self
        searchLocationBar.delegate = self
        
        searchPlaceBar.placeholder = UILabels.localizeWithoutComment(key: UILabels.SearchPlaceBarPlaceHolder)
        searchLocationBar.placeholder = UILabels.localizeWithoutComment(key: UILabels.SearchLocationBarPlaceHolder)
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
        
        if isSearchPlaceBar
        {
            return arrayPlace.count
        }
        else
        {
            return arrayLocation.count
        }
    }
    
    //MAJ Table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewPlace.dequeueReusableCell(withIdentifier: Service.SearchPlaceIdCell) as! SearchPlaceTableViewCell
        
        if isSearchPlaceBar
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
        }
        
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
        }
        
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("location error is = \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        print("Current Locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    //When a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableViewPlace.cellForRow(at: indexPath) as! SearchPlaceTableViewCell
        
        if cell.isLocationCell
        {
            searchLocationBar.text = cell.namePlaceLbl.text
            
            arrayLocation.removeAll()
            
            searchPlaceBar.becomeFirstResponder()
            isSearchPlaceBar = true
            isSearchLocationBar = false
            
            if !(searchPlaceBar.text?.isEmpty)! && !(searchPlaceBar.text?.isEmpty)!
            {
                let namePlace = searchPlaceBar.text!
                let city : String = searchLocationBar.text ?? ""
                let type : String = "&type=restaurant|bakery|bar|cafe"
                let APIKey : String = "&key=\(Service.AraGooglePlaceAPIKey)"
                let language : String = "&language=\(Locale.current.languageCode!)"
                var url = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
                let query = ("query=\(namePlace)+\(city)\(type)\(APIKey)\(language)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                url.append("\(query!)")
                self.arrayPlace.removeAll()
                GoogleServices.performGoogleQuery(url: URL(string: url)!, completion: { (json) in
                    
                    Place.jsonToPlaces(tab: json, requestPhoto: false, completion: { (placesConverted) in
                        self.arrayPlace = placesConverted
                        self.tableViewPlace.reloadData()
                    })
                })
            }
        }
        else
        {
            let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
            let desController : PlaceViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.PlaceViewController) as! PlaceViewController
            
            desController.place.idPlace = cell.placeId
            self.navigationController?.pushViewController(desController, animated: true)
        }
    }
}

extension SearchPlaceViewController: UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !(searchLocationBar.text?.isEmpty)! && !(searchPlaceBar.text?.isEmpty)!
        {
            let namePlace = searchPlaceBar.text!
            let city : String = searchLocationBar.text ?? ""
            let type : String = "&type=restaurant|bakery|bar|cafe"
            let APIKey : String = "&key=\(Service.AraGooglePlaceAPIKey)"
            let language : String = "&language=\(Locale.current.languageCode!)"
            var url = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
            let query = ("query=\(namePlace)+\(city)\(type)\(APIKey)\(language)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            url.append("\(query!)")
            self.arrayPlace.removeAll()
            GoogleServices.performGoogleQuery(url: URL(string: url)!, completion: { (json) in
                
                Place.jsonToPlaces(tab: json, requestPhoto: false, completion: { (placesConverted) in
                    self.arrayPlace = placesConverted
                    self.tableViewPlace.reloadData()
                })
            })
            
            /* TODO
            let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
            let desController : UIViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.SearchPlaceDetailViewController) as! SearchPlaceDetailViewController
            
            desController.hidesBottomBarWhenPushed=false
            self.navigationController?.pushViewController(desController, animated: true)*/
            
        }
        else if (searchPlaceBar.text?.isEmpty)!
        {
            Service.showAlert(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.ErrorTitle), message: UIMessages.localizeWithoutComment(key: UIMessages.ErrorEnterPlace))
        }
        else if (searchLocationBar.text?.isEmpty)!
        {
            Service.showAlert(on: self, style: .alert, title: UIMessages.localizeWithoutComment(key: UIMessages.ErrorTitle), message: UIMessages.localizeWithoutComment(key: UIMessages.ErrorEnterLocation))
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar == searchPlaceBar
        {
            if (searchPlaceBar.text?.isEmpty)!
            {
                self.arrayPlace = [Place]()
                isSearchPlaceBar = true
                isSearchLocationBar = false
            }
        }
        else if searchBar == searchLocationBar
        {
            if (searchPlaceBar.text?.isEmpty)!
            {
                self.arrayLocation = [GMSAutocompletePrediction]()
                isSearchPlaceBar = false
                isSearchLocationBar = true
            }
        }
        tableViewPlace.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (searchBar.text?.isEmpty)!
        {
            if searchBar == searchPlaceBar
            {
                self.arrayPlace = [Place]()
                isSearchPlaceBar = true
                isSearchLocationBar = false
            }
            else if searchBar == searchLocationBar
            {
                self.arrayLocation = [GMSAutocompletePrediction]()
                isSearchPlaceBar = false
                isSearchLocationBar = true
            }
            tableViewPlace.reloadData()
        }
        else
        {
            let searchStr = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
            
            if searchStr == ""
            {
                if searchBar == searchPlaceBar
                {
                    self.arrayPlace = [Place]()
                    isSearchPlaceBar = true
                    isSearchLocationBar = false
                }
                else if searchBar == searchLocationBar
                {
                    self.arrayLocation = [GMSAutocompletePrediction]()
                    isSearchPlaceBar = false
                    isSearchLocationBar = true
                }
            }
            else
            {
                if !(searchLocationBar.text?.isEmpty)! && !(searchPlaceBar.text?.isEmpty)!
                {
                    if searchBar == searchPlaceBar
                    {
                        isSearchPlaceBar = true
                        isSearchLocationBar = false
                        
                        let namePlace : String = searchStr
                        let city : String = searchLocationBar.text ?? ""
                        let type : String = "&type=restaurant|bakery|bar|cafe"
                        let APIKey : String = "&key=\(Service.AraGooglePlaceAPIKey)"
                        let language : String = "&language=\(Locale.current.languageCode!)"
                        var url = "https://maps.googleapis.com/maps/api/place/textsearch/json?"
                        let query = ("query=\(namePlace)+\(city)\(type)\(APIKey)\(language)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                        url.append("\(query!)")                        
                        self.arrayPlace.removeAll()
                        
                        GoogleServices.performGoogleQuery(url: URL(string: url)!, completion: { (json) in
                            
                           Place.jsonToPlaces(tab: json, requestPhoto: false, completion: { (placesConverted) in
                                self.arrayPlace = placesConverted
                                self.tableViewPlace.reloadData()
                            })
                        })
                    }
                    else
                    {
                        isSearchPlaceBar = false
                        isSearchLocationBar = true
                        
                        GMSPlacesClient.shared().autocompleteQuery(searchStr, bounds: nil, filter: filterLocation, callback: { (result, error) in
                            
                            if error == nil && result != nil
                            {
                                self.arrayLocation = result!
                            }
                        })
                    }
                    
                    self.tableViewPlace.reloadData()
                }
                else
                {
                    if searchBar == searchPlaceBar
                    {
                        isSearchPlaceBar = true
                        isSearchLocationBar = false
                        
                        GMSPlacesClient.shared().autocompleteQuery(searchStr, bounds: nil, filter: filterPlace, callback: { (result, error) in
                            
                            if error == nil && result != nil
                            {
                                var resultarrayPlace : [Place?] = [Place?]()
                                if result!.count > 0
                                {
                                    for resultPlace in result!
                                    {
                                        let newPlace = Place()
                                        newPlace.name = resultPlace.attributedPrimaryText.string
                                        newPlace.formattedAddress = resultPlace.attributedSecondaryText?.string
                                        newPlace.idPlace = resultPlace.placeID
                                        newPlace.city = self.searchLocationBar.text ?? ""
                                        
                                        resultarrayPlace.append(newPlace)
                                    }
                                }
                                
                                self.arrayPlace = resultarrayPlace
                                self.tableViewPlace.reloadData()
                            }
                        })
                    }
                    else if searchBar == searchLocationBar
                    {
                        isSearchPlaceBar = false
                        isSearchLocationBar = true
                        GMSPlacesClient.shared().autocompleteQuery(searchStr, bounds: nil, filter: filterLocation, callback: { (result, error) in
                            
                            if error == nil && result != nil
                            {
                                self.arrayLocation = result!
                                self.tableViewPlace.reloadData()
                            }
                        })
                    }
                }
            }
        }
        return true
    }
}
