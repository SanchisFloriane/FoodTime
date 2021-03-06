//
//  MyListTripsViewController.swift
//  FoodTime
//
//  Created by bob on 8/20/18.
//  Copyright © 2018 sanchisfloriane. All rights reserved.
//

import UIKit
import Firebase
import iCarousel
import GooglePlaces

class MyListTripsViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var CancelBtn: UIBarButtonItem!
    @IBOutlet weak var ForYouBtn: UITabBarItem!
    @IBOutlet weak var MyNewsBtn: UITabBarItem!
    @IBOutlet weak var MyPlacesBtn: UITabBarItem!
    @IBOutlet weak var MyProfileBtn: UITabBarItem!
    @IBOutlet weak var NavigationBar: UINavigationItem!
    @IBOutlet weak var PlacesTableView: UITableView!
    @IBOutlet weak var RecentlyViewedBtn: UIButton!
    @IBOutlet weak var SortBtn: UIButton!
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var TripsBtn: UIButton!
    @IBOutlet weak var TripsTableView: UITableView!
    
    //Trip list
    var userTripList : [UserTrip] = [UserTrip]()
    var tripList : [Trip] = [Trip]()
    var placeList : [Place] = [Place]()
    let idUser = Auth.auth().currentUser!.uid
    
    //Carousel
    var indexLastSubViewCarousel : Int?
    var placePhoto : UIImage?
    
    //Configuration Google Place API
    var placesClient : GMSPlacesClient!
    
    var recentlyViewedActived : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        
        setupView()
        
        self.loadTrips(typeOrder: ModelDB.Trip_name)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func loadTrips(typeOrder: String)
    {
        self.loadTrip(typeOrder: typeOrder, completion: { (tripListLoaded) in
            
            self.tripList = tripListLoaded
            DispatchQueue.main.async(execute: {
                self.TripsTableView.reloadData()
            })
        })
    }
    
    fileprivate func loadRecentlyViewed()
    {
        self.loadPlacesRecentlyViewed(completion: { (placesList) in
            
            self.placeList = placesList
            DispatchQueue.main.async(execute: {
                self.PlacesTableView.reloadData()
            })
        })
    }
    
    fileprivate func loadPlacesRecentlyViewed(completion:@escaping ([Place])->())
    {
        getPlaces(completion: { (placeTab) in
            
            for place in placeTab
            {
                GMSPlacesClient.shared().autocompleteQuery(searchStr, bounds: nil, filter: nil, callback: { (result, error) in
                    
                    if error == nil && result != nil
                    {
                        if result!.count > 0
                        {
                            for resultPlace in result!
                            {
                                let newPlace = Place()
                                newPlace.name = resultPlace.attributedPrimaryText.string
                                newPlace.formattedAddress = resultPlace.attributedSecondaryText?.string
                                newPlace.idPlace = resultPlace.placeID
                                
                                self.placeList.append(newPlace)
                            }
                        }
                        
                    }
                })
            }
        })
    }
    
    func getPlaces(completion: @escaping ([Place])->())
    {
        var placeTab : [Place] = [Place]()
        
        Database.database().reference().child("\(ModelDB.user_hplace)").child("\(self.idUser)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0
            {
                let listChildren = snapshot.children
                while let place = listChildren.nextObject() as? DataSnapshot
                {
                    placeTab.append(Place(idPlace: place.value as? String))
                }
                
                completion(placeTab)
            }
            else
            {
                completion(placeTab)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let sortTitle = "\(UILabels.localizeWithoutComment(key: UILabels.SortedBy)) \(UILabels.localizeWithoutComment(key: UILabels.NameTrip))"
        SortBtn.setTitle(sortTitle, for: .normal)
        self.loadTrips(typeOrder: ModelDB.Trip_name)
    }
    
    fileprivate func setupView()
    {
        TabBar.delegate = self
        PlacesTableView.isHidden = true
        recentlyViewedActived = false
        
        MyNewsBtn.title = UILabels.localizeWithoutComment(key: UILabels.MyNewsButton)
        MyPlacesBtn.title = UILabels.localizeWithoutComment(key: UILabels.MyPlacesButton)
        ForYouBtn.title = UILabels.localizeWithoutComment(key: UILabels.RecommandationsButton)
        MyProfileBtn.title = UILabels.localizeWithoutComment(key: UILabels.MyProfileButton)
        
        NavigationBar.title = UILabels.localizeWithoutComment(key: UILabels.MyTrips)
        TripsBtn.setTitle(UILabels.localizeWithoutComment(key: UILabels.TripsBtn), for: .normal)
        TripsBtn.setTitleColor(UIColor.white, for: .selected)
        TripsBtn.setTitleColor(UIColor.orange, for: .normal)
        RecentlyViewedBtn.setTitle(UILabels.localizeWithoutComment(key: UILabels.RecentlyViewedBtn), for: .normal)
        RecentlyViewedBtn.setTitleColor(UIColor.white, for: .selected)
        RecentlyViewedBtn.setTitleColor(UIColor.orange, for: .normal)
        
        let sortTitle = "\(UILabels.localizeWithoutComment(key: UILabels.SortedBy)) \(UILabels.localizeWithoutComment(key: UILabels.NameTrip))"
        SortBtn.setTitle(sortTitle, for: .normal)
        
        TripsBtn.isSelected = true
        SortBtn.contentHorizontalAlignment = .left
        SortBtn.contentEdgeInsets.left = CancelBtn.imageInsets.left
        TabBar.selectedItem = MyPlacesBtn
    }
    
    func loadTrip(typeOrder: String, completion:@escaping ([Trip])->())
    {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = Service.formatterDate
        
        var tripList : [Trip] = [Trip]()
        var index = 0
        for userTrip in userTripList
        {
            Database.database().reference().child("\(ModelDB.trips)/\(userTrip.idTrip!)").observeSingleEvent(of: .value, with: { (snapchot) in
                
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
                            if date != nil && !(date!.isEmpty)
                            {
                                startDate = formatter.date(from: date!)
                            }
                        }
                        
                        if child.key == ModelDB.Trip_endDate
                        {
                            let date = child.value as? String
                            if date != nil && !(date!.isEmpty)
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
                
                if index == self.userTripList.count
                {
                    self.sortList(tripList: tripList, typeOrder: typeOrder, completion: { (sortedTripList) in
                        completion(sortedTripList)
                    })
                }
            })
        }
        completion(tripList)
    }
    
    func sortList(tripList: [Trip], typeOrder: String, completion:@escaping ([Trip])->())
    {
        var sortedList : [Trip] = [Trip]()
        
        if typeOrder == ModelDB.Trip_name
        {
            sortedList = tripList.sorted {
                $0.name?.localizedCaseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending
            }
        }
        else if typeOrder == ModelDB.Trip_startDate
        {
            sortedList = tripList.sorted {
                $0.startDate! < $1.startDate!
            }
        }
        else if typeOrder == ModelDB.Trip_endDate
        {
            sortedList = tripList.sorted {
                $0.endDate! < $1.endDate!
            }
        }
        completion(sortedList)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        self.dismiss(animated: false, completion: nil)
        
        let item = tabBar.selectedItem
        
        if item == MyNewsBtn
        {
            let desController : HomeViewController = mainStoryboard.instantiateViewController(withIdentifier: Service.HomeViewController) as! HomeViewController
            self.navigationController?.pushViewController(desController, animated: true)
        }
        else if item == MyProfileBtn
        {
            
        }
        else if item == ForYouBtn
        {
            
        }
    }
    
    @IBAction func buttonTapped(sender: UIButton) {
        
        if sender == TripsBtn || sender == RecentlyViewedBtn
        {
            if TripsBtn.backgroundColor == UIColor.orange {
                TripsBtn.backgroundColor = UIColor.groupTableViewBackground
                TripsBtn.isSelected = false
                RecentlyViewedBtn.backgroundColor = UIColor.orange
                RecentlyViewedBtn.isSelected = true
            }
            else
            {
                TripsBtn.backgroundColor = UIColor.orange
                TripsBtn.isSelected = true
                RecentlyViewedBtn.backgroundColor = UIColor.groupTableViewBackground
                RecentlyViewedBtn.isSelected = false
            }
            
            if sender == TripsBtn
            {
                PlacesTableView.isHidden = true
                TripsTableView.isHidden = false
                recentlyViewedActived = false
                self.loadTrips(typeOrder: ModelDB.Trip_name)
            }
            else
            {
                TripsTableView.isHidden = true
                recentlyViewedActived = true
                PlacesTableView.isHidden = false
                self.loadRecentlyViewed()
                
            }
        }
    }
    
    @IBAction func sortTable() {
        
        let alert = UIAlertController(title: UILabels.localizeWithoutComment(key: UILabels.SortByAlert), message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: UILabels.localizeWithoutComment(key: UILabels.NameTrip), style: .default, handler: { (action) in
            self.loadTrips(typeOrder: ModelDB.Trip_name)
            let sortTitle = "\(UILabels.localizeWithoutComment(key: UILabels.SortedBy)) \(UILabels.localizeWithoutComment(key: UILabels.NameTrip))"
            self.SortBtn.setTitle(sortTitle, for: .normal)
        }))
        
        alert.addAction(UIAlertAction(title: UILabels.localizeWithoutComment(key: UIMessages.SortStartDate), style: .default, handler: { (action) in
            self.loadTrips(typeOrder: ModelDB.Trip_startDate)
            let sortTitle = "\(UILabels.localizeWithoutComment(key: UILabels.SortedBy)) \(UILabels.localizeWithoutComment(key: UIMessages.SortStartDate))"
            self.SortBtn.setTitle(sortTitle, for: .normal)
        }))
        
        alert.addAction(UIAlertAction(title: UILabels.localizeWithoutComment(key: UIMessages.SortEndDate), style: .default, handler: { (action) in
            self.loadTrips(typeOrder: ModelDB.Trip_endDate)
            let sortTitle = "\(UILabels.localizeWithoutComment(key: UILabels.SortedBy)) \(UILabels.localizeWithoutComment(key: UIMessages.SortEndDate))"
            self.SortBtn.setTitle(sortTitle, for: .normal)
        }))
        
        let cancel = UIAlertAction(title: UIMessages.localizeWithoutComment(key: UIMessages.Cancel), style: .cancel)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension MyListTripsViewController: UITableViewDelegate, UITableViewDataSource, iCarouselDelegate, iCarouselDataSource
{
    //Number of image in the carousel
    func numberOfItems(in carousel: iCarousel) -> Int {
        let carouselTrip = carousel as! CarouselTrips
        return carouselTrip.tempviews.count
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
        let carouselTrip = carousel as! CarouselTrips
        return carouselTrip.tempviews[index]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if recentlyViewedActived
        {
            let cell : MyListPlaceRecentlyViewedTableViewCell = PlacesTableView.dequeueReusableCell(withIdentifier: Service.MyListPlaceRecentlyViewedIdCell) as! MyListPlaceRecentlyViewedTableViewCell
            
            cell.namePlace.text = placeList[indexPath.row].name
            cell.idPlace = placeList[indexPath.row].idPlace
            cell.addressPlace.text = placeList[indexPath.row].formattedAddress
            
            GoogleServices.loadPlace(idPlace: cell.idPlace, completion: { (place) in
                
                //load first photo of the place
                self.loadFirstPhotoForPlace(carouselView: nil, placeID: place.idPlace!, completion: {
                    
                    //add photo to carousel
                    if self.placePhoto != nil
                    {
                      cell.imagePlace.image = Service.imageWithImage(image: self.placePhoto!, scaledToSize: CGSize(width: cell.imagePlace.frame.width, height: cell.imagePlace.frame.height))
                    }
                })
            })
            return cell
        }
        else
        {
            let cell : MyListTripsTableViewCell = TripsTableView.dequeueReusableCell(withIdentifier: Service.MyListTripsIdCell) as! MyListTripsTableViewCell
            cell.titleTripButton.sizeToFit()
            cell.titleTripButton.setTitle(tripList[indexPath.row].name, for: .normal)
            
            cell.idTrip = tripList[indexPath.row].idTrip
            cell.CarouselTrip.tempviews.removeAll()
            
            getPlaceFromTrip(idTrip: cell.idTrip!, completion: { (placeList) in
                //load each place in the carousel for the cell
                var index : Int = 0
                if placeList.isEmpty
                {
                    cell.CarouselTrip.isScrollEnabled = false
                    while index<3
                    {
                        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: cell.CarouselTrip.frame.width/3, height: cell.CarouselTrip.frame.height))
                        tempView.backgroundColor = self.view?.backgroundColor
                        let button = FoodTimeButton(frame: tempView.frame)
                        var img = UIImage(named: Service.CrossIcon)
                        img = Service.imageWithImage(image: img!, scaledToSize: CGSize(width: cell.CarouselTrip.frame.width/3, height: cell.CarouselTrip.frame.height))
                        button.setImage(img, for: .normal)
                        tempView.addSubview(button)
                        cell.CarouselTrip.tempviews.append(tempView)
                        index += 1
                    }
                    cell.CarouselTrip.reloadData()
                    cell.CarouselTrip.currentItemIndex = 1
                    cell.titleTripButton.trip = Trip(idTrip: self.tripList[indexPath.row].idTrip, name: self.tripList[indexPath.row].name, startDate: self.tripList[indexPath.row].startDate, endDate: self.tripList[indexPath.row].endDate)
                    cell.titleTripButton.trip?.placeList = placeList
                    cell.titleTripButton.addTarget(self, action: #selector(self.showManageTripViewController(_:)), for: .touchUpInside)
                }
                else
                {
                    for place in placeList
                    {
                        GoogleServices.loadPlace(idPlace: place.idPlace, completion: { (place) in
                            
                            //load first photo of the place
                            self.loadFirstPhotoForPlace(carouselView: cell.CarouselTrip, placeID: place.idPlace!, completion: {
                                //add photo to carousel
                                let tempView = UIView(frame: CGRect(x: 0, y: 0, width: cell.CarouselTrip.frame.width/3, height: cell.CarouselTrip.frame.height))
                                tempView.backgroundColor = self.view?.backgroundColor
                                let button = FoodTimeButton(frame: tempView.frame)
                                self.placePhoto = Service.imageWithImage(image: self.placePhoto!, scaledToSize: CGSize(width: cell.CarouselTrip.frame.width/3, height: cell.CarouselTrip.frame.height))
                                button.setImage(self.placePhoto, for: .normal)
                                button.idPlace = place.idPlace
                                button.addTarget(self, action: #selector(self.showPlaceViewController(_:)), for: .touchUpInside)
                                tempView.addSubview(button)
                                cell.CarouselTrip.tempviews.append(tempView)
                                index += 1
                                
                                if index == placeList.count
                                {
                                    if placeList.count < 3
                                    {
                                        cell.CarouselTrip.isScrollEnabled = false
                                        while index<3
                                        {
                                            let tempView = UIView(frame: CGRect(x: 0, y: 0, width: cell.CarouselTrip.frame.width/3, height: cell.CarouselTrip.frame.height))
                                            tempView.backgroundColor = self.view?.backgroundColor
                                            let button = FoodTimeButton(frame: tempView.frame)
                                            var img = UIImage(named: Service.CrossIcon)
                                            img = Service.imageWithImage(image: img!, scaledToSize: CGSize(width: cell.CarouselTrip.frame.width/3, height: cell.CarouselTrip.frame.height))
                                            button.setImage(img, for: .normal)
                                            tempView.addSubview(button)
                                            cell.CarouselTrip.tempviews.append(tempView)
                                            index += 1
                                        }
                                    }
                                    cell.CarouselTrip.reloadData()
                                    cell.CarouselTrip.currentItemIndex = 1
                                    cell.titleTripButton.trip = Trip(idTrip: self.tripList[indexPath.row].idTrip, name: self.tripList[indexPath.row].name, startDate: self.tripList[indexPath.row].startDate, endDate: self.tripList[indexPath.row].endDate)
                                    cell.titleTripButton.trip?.placeList = placeList
                                    cell.titleTripButton.addTarget(self, action: #selector(self.showManageTripViewController(_:)), for: .touchUpInside)
                                }
                            })
                        })
                    }
                }
            })
            return cell
        }
    }
    
    @objc func showPlaceViewController(_ sender: FoodTimeButton) {
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : PlaceViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.PlaceViewController) as! PlaceViewController
        desController.place.idPlace = sender.idPlace
        self.navigationController?.pushViewController(desController, animated: true)
    }
    
    
    @objc func showManageTripViewController(_ sender: FoodTimeButton) {
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        
        if sender.trip!.placeList.isEmpty
        {
            let desController : ManageTripEmptyViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.ManageTripEmptyViewController) as! ManageTripEmptyViewController
            desController.trip = sender.trip
            self.navigationController?.pushViewController(desController, animated: true)
        }
        else
        {
            let desController : ManageTripViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.ManageTripViewController) as! ManageTripViewController
            desController.trip = sender.trip
            self.navigationController?.pushViewController(desController, animated: true)
        }
    }
    
    func loadFirstPhotoForPlace(carouselView: iCarousel?, placeID: String, completion:@escaping ()->())
    {
        placePhoto = nil
        placesClient.lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            }
            
            if photos?.results != nil && !(photos?.results.isEmpty)!
            {
                let photoMetaData : GMSPlacePhotoMetadata = photos!.results.first!
                self.loadImageForMetadata(photoMetaData: photoMetaData, completion: {
                    completion()
                })
            }
            else
            {
                self.placePhoto = UIImage(named: Service.CrossIcon)
                completion()
            }
        }
    }
    
    func loadImageForMetadata(photoMetaData: GMSPlacePhotoMetadata, completion:@escaping ()->())
    {
        self.placesClient.loadPlacePhoto(photoMetaData, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                self.placePhoto = photo
                completion()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if recentlyViewedActived
        {
            return self.placeList.count
        }
        else
        {
            return self.tripList.count
        }
    }
}

