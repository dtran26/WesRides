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
import MBProgressHUD
import ReachabilitySwift
import SwiftMessages

class HomeViewController: UIViewController{
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openMenu: UIBarButtonItem!
    @IBOutlet weak var rideSegmentedControl: UISegmentedControl!
    let refreshControl = UIRefreshControl()
    var filteredPicker: ActionSheetMultipleStringPicker!
    var requestedRides = [Ride]()
    var offeredRides = [Ride]()
    var hasInternet: Bool {
        if let reachability = Reachability() {
            if reachability.currentReachabilityStatus == .notReachable {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        configureTableView()
        DispatchQueue.once(token: "com.dtran.WesRides") {
            loadingIndicator()
        }
        reloadTimeline()
        toolBar.barTintColor = UIColor.flatWhite
        noInternet()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTimeline), name: NSNotification.Name(rawValue: "upload"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.reloadTimeline()
        self.tableView.reloadData()
    }
    
    func loadingIndicator(){
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = .indeterminate
        loadingNotification.label.text = "Loading..."
    }
    
    func noInternet(){
        if !hasInternet {
            let warning = MessageView.viewFromNib(layout: .CardView)
            warning.configureTheme(.warning)
            warning.configureDropShadow()
            warning.button?.isHidden = true
            let iconText = ["🤔", "😖", "🙄", "😶", "😔", "😰"].sm_random()!
            var warningConfig = SwiftMessages.defaultConfig
            warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            warningConfig.duration = .seconds(seconds: 2.0)
            warning.configureContent(title: "", body: "The Internet connection appears to be offline", iconText: iconText)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
        
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
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        })
        
    }
    
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.contentInset = UIEdgeInsetsMake(45, 0, 0, 0)
        tableView.backgroundColor = UIColor.flatWhite
        hideHairline()
        
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
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.flatWhite
    }
}

extension HomeViewController: HideableHairlineViewController{
    
}

