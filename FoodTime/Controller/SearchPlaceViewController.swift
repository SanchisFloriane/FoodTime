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
    var arrayLocation : [GMSAutocompletePrediction] = [GMSAutocompletePrediction]()
    var findPlaceLocation : Bool = false
    
    lazy var filter : GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        return filter
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
        
        if !(searchLocationBar.text?.isEmpty)! && !(searchPlaceBar.text?.isEmpty)!
        {
            findPlaceLocation = true
        }
        
        if !findPlaceLocation
        {
            if !(searchLocationBar.text?.isEmpty)!
            {
                return arrayLocation.count
            }
            else
            {
                return arrayAddress.count
            }
        }
        else
        {
            let city : String = arrayAddress[0].attributedPrimaryText.string
            let txtAppend = ("query=restaurant+in+\(city)&key=\(Service.GooglePlaceAPIWSKey)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = "https://maps.googleapis.com/maps/api/place/textsearch/json?\(txtAppend!)"
            if let openUrl  = URL(string: url) {
                UIApplication.shared.open(openUrl, options: [:], completionHandler: nil)
                performGoogleQuery(url: openUrl)
            }
            return arrayAddress.count
        }
    }
    
    func performGoogleQuery(url: URL)
    {
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            
            if error != nil
            {
                print("An error occured: \(String(describing: error))")
                return
            }
            
            do
            {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
                
                // Parse the json results into an array of MKMapItem objects
                if let places = json?["results"] as? [[String : Any]]
                {
                    print("Places Count = \(places.count)")     // Returns 20 on first pass and 0 on second.
                    
                    for place in places
                    {
                        let name = place["name"] as! String
                        let address = place["formatted_address"] as! String
                        let id = place["place_id"] as! String
                        let opening_hours = place["opening_hours"] as! String
                        print("\(name)")
                        print("\(address)")
                        print("\(id)")
                        print("\(opening_hours)")
                     
                        /*if let geometry = place["geometry"] as? [String : Any]
                        {
                            if let location = geometry["location"] as? [String : Any]
                            {
                                let lat = location["lat"] as! CLLocationDegrees
                                let long = location["lng"] as! CLLocationDegrees
                                let coordinate = CLLocationCoordinate2DMake(lat, long)
                            }
                        }*/
                    }
                }
                // If there is another page of results,
                // configure the new url and run the query again.
                if let pageToken = json?["next_page_token"]
                {
                    let newURL : URL = URL(string: "https://maps.googleapis.com/maps/api/place/textsearch/json?pagetoken=\(pageToken)&key=\(Service.GooglePlaceAPIKey)")!
                    self.performGoogleQuery(url: newURL)
                }
            }
            catch
            {
                print("error serializing JSON: \(error)")
            }
        })
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableViewPlace.dequeueReusableCell(withIdentifier: Service.SearchPlaceIdCell) as! SearchPlaceTableViewCell
        
        if (searchLocationBar.text?.isEmpty)! || findPlaceLocation
        {
            cell.namePlaceLbl.attributedText = arrayAddress[indexPath.row].attributedPrimaryText
            cell.addressPlaceLbl.attributedText = arrayAddress[indexPath.row].attributedSecondaryText
            cell.placeId = arrayAddress[indexPath.row].placeID!
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
                
                let coordinate₀ = CLLocation(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableViewPlace.cellForRow(at: indexPath) as! SearchPlaceTableViewCell
        
        if cell.isLocationCell
        {
            searchLocationBar.text = cell.namePlaceLbl.text
            var place : GMSAutocompletePrediction?
            for location in arrayLocation
            {
                if location.placeID == cell.placeId
                {
                    place = location
                    break
                }
            }
            
            arrayLocation.removeAll()
            
            if (searchPlaceBar.text?.isEmpty)!
            {
                findPlaceLocation = false
                tableViewPlace.reloadData()
                arrayLocation.append(place!)
                searchPlaceBar.becomeFirstResponder()
            }
            else
            {
                findPlaceLocation = true
                arrayLocation.append(place!)
                tableViewPlace.reloadData()
            }
        }
        else
        {
            //redirect view place
        }
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
            if searchBar == searchPlaceBar
            {
                self.arrayAddress = [GMSAutocompletePrediction]()
            }
            else if searchBar == searchLocationBar
            {
                self.arrayLocation = [GMSAutocompletePrediction]()
            }
        }
        else
        {
            let searchStr = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
            
            if searchStr == ""
            {
                if searchBar == searchPlaceBar
                {
                    self.arrayAddress = [GMSAutocompletePrediction]()
                }
                else if searchBar == searchLocationBar
                {
                    self.arrayLocation = [GMSAutocompletePrediction]()
                }
            }
            else
            {
                if searchBar == searchPlaceBar
                {
                    GMSPlacesClient.shared().autocompleteQuery(searchStr, bounds: nil, filter: filter, callback: { (result, error) in
                        
                        if error == nil && result != nil
                        {
                            self.arrayAddress = result!
                            print(result!)
                            self.tableViewPlace.reloadData()
                        }
                    })
                }
                else if searchBar == searchLocationBar
                {
                    GMSPlacesClient.shared().autocompleteQuery(searchStr, bounds: nil, filter: filterLocation, callback: { (result, error) in
                        
                        if error == nil && result != nil
                        {
                            self.arrayLocation = result!
                            print(result!)
                            self.tableViewPlace.reloadData()
                        }
                    })
                }
            }
        }
        return true
    }
}
