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
    @IBOutlet weak var RecentlyViewedBtn: UIButton!
    @IBOutlet weak var SortBtn: UIButton!
    @IBOutlet weak var TabBar: UITabBar!
    @IBOutlet weak var TripsBtn: UIButton!
    @IBOutlet weak var TripsTableView: UITableView!
    
    //Trip list
    var userTripList : [UserTrip] = [UserTrip]()
    var tripList : [Trip] = [Trip]()
    let idUser = Auth.auth().currentUser!.uid
    
    //Carousel
    var indexLastSubViewCarousel : Int?
    var placePhotoCarousel : UIImage?
    
    //Configuration Google Place API
    var placesClient : GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placesClient = GMSPlacesClient.shared()
        
        setupView()
        
        self.loadTrips()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* override func viewDidAppear(_ animated: Bool) {
     self.loadTrips()
     }*/
    
    fileprivate func loadTrips()
    {
        self.loadTrip(completion: { (tripListLoaded) in
            
            self.tripList = tripListLoaded
            DispatchQueue.main.async(execute: {
                self.TripsTableView.reloadData()
            })
        })
    }
    
    fileprivate func setupView()
    {
        TabBar.delegate = self
        
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
        //RecentlyViewedBtn.isEnabled = false
        let sortTitle = "\(UILabels.localizeWithoutComment(key: UILabels.SortedBy)) \(UILabels.localizeWithoutComment(key: UILabels.Alphabetical))"
        SortBtn.setTitle(sortTitle, for: .normal)
        
        TripsBtn.isSelected = true
        SortBtn.contentHorizontalAlignment = .left
        SortBtn.contentEdgeInsets.left = CancelBtn.imageInsets.left
        TabBar.selectedItem = MyPlacesBtn
    }
    
    func loadTrip(completion:@escaping ([Trip])->())
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
                
                if index == self.userTripList.count
                {
                    completion(tripList)
                }
            })
        }
        completion(tripList)
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
        }
    }
    
    @IBAction func sortTable() {
        
        let alert = UIAlertController(title: UILabels.localizeWithoutComment(key: UILabels.SortByAlert), message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: UILabels.localizeWithoutComment(key: UILabels.Alphabetical), style: .default, handler: { (action) in
            //SORT TO DO
        }))
        
        alert.addAction(UIAlertAction(title: UILabels.localizeWithoutComment(key: UILabels.Recent), style: .default, handler: { (action) in
            //SORT TO DO
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
        
        let cell : MyListTripsTableViewCell = TripsTableView.dequeueReusableCell(withIdentifier: Service.MyListTripsIdCell) as! MyListTripsTableViewCell
        cell.TitleTrip.text = tripList[indexPath.row].name
        cell.idTrip = tripList[indexPath.row].idTrip
        
        getPlaceFromTrip(idTrip: cell.idTrip!, completion: { (placeList) in
            //load each place in the carousel for the cell
            var index : Int = 0
            for place in placeList
            {
                GoogleServices.loadPlace(idPlace: place.idPlace, completion: { (place) in
                    
                    //load first photo of the place
                    self.loadFirstPhotoForPlace(carouselView: cell.CarouselTrip, placeID: place.idPlace!, completion: {
                        //add photo to carousel
                        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: cell.CarouselTrip.frame.width/3, height: cell.CarouselTrip.frame.height))
                        tempView.backgroundColor = self.view?.backgroundColor
                        let button = CarouselButton(frame: tempView.frame)
                        self.placePhotoCarousel = Service.imageWithImage(image: self.placePhotoCarousel!, scaledToSize: CGSize(width: cell.CarouselTrip.frame.width, height: cell.CarouselTrip.frame.height))
                        button.setImage(self.placePhotoCarousel, for: .normal)
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
                                while index<=3
                                {
                                    let tempView = UIView(frame: CGRect(x: 0, y: 0, width: cell.CarouselTrip.frame.width/3, height: cell.CarouselTrip.frame.height))
                                    tempView.backgroundColor = self.view?.backgroundColor
                                    let button = CarouselButton(frame: tempView.frame)
                                    tempView.addSubview(button)
                                    cell.CarouselTrip.tempviews.append(tempView)
                                    index += 1
                                }
                            }
                            cell.CarouselTrip.reloadData()
                            cell.CarouselTrip.currentItemIndex = 1
                        }
                    })
                })
            }
        })
        return cell
    }
    
    @objc func showPlaceViewController(_ sender: CarouselButton) {
        
        let mainStoryboard: UIStoryboard! = UIStoryboard(name: Service.MainStoryboard, bundle: nil)
        let desController : PlaceViewController! = mainStoryboard.instantiateViewController(withIdentifier: Service.PlaceViewController) as! PlaceViewController
        desController.place.idPlace = sender.idPlace
        self.navigationController?.pushViewController(desController, animated: true)
    }
    
    func loadFirstPhotoForPlace(carouselView: iCarousel, placeID: String, completion:@escaping ()->())
    {
        placePhotoCarousel = nil
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
                self.placePhotoCarousel = UIImage(named: Service.CrossIcon)
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
                self.placePhotoCarousel = photo
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
        
        return self.tripList.count
    }
}

