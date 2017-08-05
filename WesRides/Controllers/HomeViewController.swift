//
//  ViewController.swift
//  WesRides
//
//  Created by Dan on 7/7/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import ActionSheetPicker_3_0
import DZNEmptyDataSet
import ChameleonFramework


class HomeViewController: UIViewController{
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var rideView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openMenu: UIBarButtonItem!
    @IBOutlet weak var rideSegmentedControl: UISegmentedControl!
    var filteredPicker: ActionSheetMultipleStringPicker!
    var requestedRides = [Ride]()
    var offeredRides = [Ride]()
    let refreshControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        configureTableView()
        reloadTimeline()
        toolBar.barTintColor = UIColor.flatWhite
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTimeline), name: NSNotification.Name(rawValue: "upload"), object: nil)
    }
    
    func sideMenu() {
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    @IBAction func rideSegmentedControlValueChanged(_ sender: Any) {
        self.tableView.reloadData()
    }
    
    
    func reloadTimeline() {
        let delayTime = DispatchTime.now() + Double(Int64(1.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        UserService.posts(own: false, completion: { (requestrides, offerrides) in
            self.requestedRides = requestrides
            self.offeredRides = offerrides
            if self.refreshControl.isRefreshing {
                DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
                    self.refreshControl.endRefreshing()
                }
            }
            self.tableView.reloadData()
            self.tableView.emptyDataSetSource = self
            self.tableView.emptyDataSetDelegate = self
        })
        
    }
    
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
        hideHairline()
        tableView.backgroundColor = UIColor.flatWhite
        
    }
    
    
    @IBAction func newRideTouched(_ sender: UIButton) {
        performSegue(withIdentifier: "newRideSegue", sender: self)
    }
    
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func searchTouched(_ sender: Any) {
        self.filteredPicker = ActionSheetMultipleStringPicker.init(title: "Filter Rides", rows: [
            ["From","Wesleyan", "Bradley", "New Haven", "Boston", "New York City"],
            ["To","Wesleyan", "Bradley", "New Haven", "Boston", "New York City"]
            ], initialSelection: [0, 0], doneBlock: {
                picker, indexes, values in
                let pickerArray = values as! Array<String>
                UserService.posts(own: false, completion: { (requestrides, offerrides) in
                    self.requestedRides = requestrides
                    self.offeredRides = offerrides
                })
                
                switch self.rideSegmentedControl.selectedSegmentIndex {
                    
                case 0: //requests
                    self.requestedRides = self.requestedRides.filter({ (Ride) -> Bool in
                        if pickerArray[0] != "From" && pickerArray[1] == "To"{
                            return Ride.from == pickerArray[0]
                        }
                        else if pickerArray[0] == "From" && pickerArray[1] != "To"{
                            return Ride.destination == pickerArray[1]
                        }
                        else if pickerArray[0] != "From" && pickerArray[1] != "To"{
                            return (Ride.from == pickerArray[0] && Ride.destination == pickerArray[1])
                        }
                        return true
                    })
                case 1: //offers
                    self.offeredRides = self.offeredRides.filter({ (Ride) -> Bool in
                        if pickerArray[0] != "From" && pickerArray[1] == "To"{
                            return Ride.from == pickerArray[0]
                        }
                        else if pickerArray[0] == "From" && pickerArray[1] != "To"{
                            return Ride.destination == pickerArray[1]
                        }
                        else if pickerArray[0] != "From" && pickerArray[1] != "To"{
                            return (Ride.from == pickerArray[0] && Ride.destination == pickerArray[1])
                        }
                        return true
                    })
                default:
                    return
                }
                self.tableView.reloadData()
                
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
        
        self.filteredPicker.tapDismissAction = TapAction.cancel
        self.filteredPicker.show()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "detailedRide"{
                if let cell = sender as? UITableViewCell{
                    let index = tableView.indexPath(for: cell)
                    let detailedRideVC = segue.destination as! DetailedRideViewController
                    switch rideSegmentedControl.selectedSegmentIndex{
                    case 0: //requests
                        let ride = requestedRides[index!.row]
                        detailedRideVC.detailedRide = ride
                    case 1:  // offers
                        let ride = offeredRides[index!.row]
                        detailedRideVC.detailedRide = ride
                    default:
                        return
                    }
                }
            }
        }
    }
    
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch rideSegmentedControl.selectedSegmentIndex{
        case 0: //requests
            return requestedRides.count
        case 1:  // offers
            return offeredRides.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var post : Ride?
        let rideCell = tableView.dequeueReusableCell(withIdentifier: "RideCell", for: indexPath) as! RideCell

        switch rideSegmentedControl.selectedSegmentIndex {
        case 0:  // requests
            post = requestedRides[indexPath.row]
        case 1:  // offers
            post = offeredRides[indexPath.row]
        default:
            break
        }
        
        rideCell.destinationLabel.text = post?.destination
        rideCell.fromLabel.text = post?.from
        rideCell.timeLabel.text = post?.pickUpTime.string(dateStyle: .long, timeStyle: .short)
        rideCell.creatorLabel.text = post?.creatorDisplayName
        return rideCell
    }
}

extension HomeViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let str = "No Rides Found 😔"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}

extension HomeViewController: HideableHairlineViewController{
    
}

