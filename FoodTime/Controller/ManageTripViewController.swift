//
//  MangaTripViewController.swift
//  FoodTime
//
//  Created by floriane sanchis on 27/08/2018.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase

class ManageTripViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var addTripButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var manageButton: UIBarButtonItem!
    @IBOutlet weak var mapTripButton: UIButton!
    @IBOutlet weak var nameTripLbl: UILabel!
    @IBOutlet weak var titlePage: UINavigationItem!
    @IBOutlet weak var tripTableView: UITableView!
    
    var trip : Trip?
    
    //Localisation user
    let locationManager = CLLocationManager()
    var isUserLocalized : Bool = false
    var idUser = Auth.auth().currentUser!.uid
    
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
        loadTrip()
        
        getPlaceFromTrip(idTrip: trip!.idTrip!, completion: { (placeListFromTrip) in
            self.trip?.placeList = placeListFromTrip
            self.tripTableView.reloadData()
        })
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
    
    @IBAction func manage(_ sender: UIBarButtonItem) {
    
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : ModifyTripViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.ModifyTripViewController) as! ModifyTripViewController
        desController.trip = self.trip
        self.navigationController?.pushViewController(desController, animated: true)
    }
    
    @IBAction func showMap() {
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : SearchPlaceMapViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.SearchPlaceMapViewController) as! SearchPlaceMapViewController
        self.navigationController?.pushViewController(desController, animated: true)
    }
    
    fileprivate func setupView()
    {
        self.addTripButton.titleLabel?.text = UILabels.localizeWithoutComment(key: UILabels.AddTrip)
        self.mapTripButton.titleLabel?.text = UILabels.localizeWithoutComment(key: UILabels.Map)
        self.titlePage.title = UILabels.localizeWithoutComment(key: UILabels.ManageMyTrip)
    }

    func loadTrip()
    {
        nameTripLbl.text = self.trip?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        getPlaceFromTrip(idTrip: trip!.idTrip!, completion: { (placeListFromTrip) in
            self.trip?.placeList = placeListFromTrip
            
            if self.trip!.placeList.count > 0
            {
                self.tripTableView.reloadData()
            }
            else
            {
                let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
                let desController : ManageTripEmptyViewController = mainStoryboard.instantiateViewController(withIdentifier: Service.ManageTripEmptyViewController) as! ManageTripEmptyViewController
                desController.trip = self.trip
                self.navigationController?.pushViewController(desController, animated: true)
            }
        })
    }
    
   func loadFirstPhotoForPlace(placeID: String, completion:@escaping (UIImage?)->())
    {
        self.placesClient.lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            }
            
            if photos?.results != nil && !(photos?.results.isEmpty)!
            {
                let photoMetaData : GMSPlacePhotoMetadata = photos!.results.first!
                self.loadImageForMetadata(photoMetaData: photoMetaData, completion: { (photo) in
                    completion(photo)
                })
            }
            else
            {
                completion(UIImage(named: Service.CrossIcon))
            }
        }
    }
    
    func loadImageForMetadata(photoMetaData: GMSPlacePhotoMetadata, completion:@escaping (UIImage?)->())
    {
        self.placesClient.loadPlacePhoto(photoMetaData, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(photo)
            }
        })
    }
    
    func getPlaceFromTrip(idTrip: String, completion:@escaping ([Place])->())
    {
        var placeFromTripList : [Place] = [Place]()
        
        //Get all trips of the current user for the place selected
        Database.database().reference().child("\(ModelDB.user_place)/\(idUser)").observeSingleEvent(of: .value, with: { (snapchot) in
            
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
}


extension ManageTripViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : ManageTripTableViewCell = self.tripTableView.dequeueReusableCell(withIdentifier: Service.ManageTripIdCell) as! ManageTripTableViewCell
        
        GoogleServices.loadPlace(idPlace: self.trip?.placeList[indexPath.row].idPlace!, completion: { (placeConverted) in
            
            DispatchQueue.main.async(execute: {
            
            //load first photo of the place
            self.loadFirstPhotoForPlace(placeID: placeConverted.idPlace!, completion: { (photo) in
             
                if photo != nil
                {
                    //add photo to carousel
                    let tempView = UIView(frame: CGRect(x: 0, y: 0, width: cell.imageTrip.frame.width, height: cell.imageTrip.frame.height))
                    tempView.backgroundColor = self.view?.backgroundColor
                    let button = FoodTimeButton(frame: tempView.frame)
                    let img = Service.imageWithImage(image: photo!, scaledToSize: CGSize(width: cell.imageTrip.frame.width, height: cell.imageTrip.frame.height))
                    button.setImage(img, for: .normal)
                    cell.imageTrip.addSubview(button)
                }
            })
                
            cell.idPlace =  placeConverted.idPlace
            cell.nameTripLbl.text = placeConverted.name
            cell.adresseTripLbl.text =  placeConverted.formattedAddress
            
            if self.isUserLocalized {
                
                self.placesClient.lookUpPlaceID(cell.idPlace!, callback: { (place, error) -> Void in
                    if let error = error {
                        print("lookup place id query error: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let place = place else {
                        print("No place details for \(cell.idPlace ?? "")")
                        return
                    }
                    
                    let coordinate₀ = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                    let coordinate₁ = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    
                    let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                    let distanceInMetric = distanceInMeters.conversionInUserMetric()
                    
                    cell.distanceLbl.attributedText = NSAttributedString(string: distanceInMetric)
                })
            }
            else
            {
                cell.distanceLbl.attributedText = NSAttributedString(string: "")
            }
            })
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            //self.trip?.placeList.remove(at: indexPath.row)
            let cell : ManageTripTableViewCell = tripTableView.cellForRow(at: indexPath) as! ManageTripTableViewCell
            
            //Get all trips of the current user for the place selected
            Database.database().reference().child("\(ModelDB.user_place)/\(idUser)").child("\(cell.idPlace!)").removeValue { (error, ref) in
                if error != nil {
                    print("error \(String(describing: error))")
                }
                else
                {
                    self.getPlaceFromTrip(idTrip: self.trip!.idTrip!, completion: { (placeListFromTrip) in
                        self.trip?.placeList = placeListFromTrip
                        self.tripTableView.reloadData()
                    })
                }
            }
        }
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
    
    //When a row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tripTableView.cellForRow(at: indexPath) as! ManageTripTableViewCell
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : PlaceViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.PlaceViewController) as! PlaceViewController
            
        desController.place.idPlace = cell.idPlace
        self.navigationController?.pushViewController(desController, animated: true)
    }
    
    @objc func showPlaceViewController(_ sender: FoodTimeButton) {
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : PlaceViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.PlaceViewController) as! PlaceViewController
        desController.place.idPlace = sender.idPlace
        self.navigationController?.pushViewController(desController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.trip?.placeList.count ?? 0
    }
}
