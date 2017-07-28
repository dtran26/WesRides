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
import TBEmptyDataSet

class HomeViewController: UIViewController, HideableHairlineViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openMenu: UIBarButtonItem!
    @IBOutlet weak var rideSegmentedControl: UISegmentedControl!
    
    var requestedRides = [Ride]()
    var offeredRides = [Ride]()
    let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sideMenu()
        configureTableView()
        // load timeline
        UserService.posts(completion: { (requestrides, offerrides) in
            self.requestedRides = requestrides
            self.offeredRides = offerrides
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            UserService.posts(completion: { (requestrides, offerrides) in
                self.requestedRides = requestrides
                self.offeredRides = offerrides
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.tableView.reloadData()
            })
        }
    }
    
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        hideHairline()
    }
    
    
    @IBAction func newRideTouched(_ sender: UIButton) {
        performSegue(withIdentifier: "newRideSegue", sender: self)
    }
    
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func searchTouched(_ sender: Any) {
        ActionSheetMultipleStringPicker.show(withTitle: "Filter Rides", rows: [
            ["From","Wesleyan", "Bradley", "New Haven", "Boston", "New York City"],
            ["To","Wesleyan", "Bradley", "New Haven", "Boston", "New York City"]
            ], initialSelection: [0, 0], doneBlock: {
                picker, indexes, values in
                let pickerArray = values as! Array<String>
                UserService.posts(completion: { (requestrides, offerrides) in
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
        var cell = UITableViewCell()
        switch rideSegmentedControl.selectedSegmentIndex {
        case 0:  // requests
            let requestCell = tableView.dequeueReusableCell(withIdentifier: "RequestRideCell", for: indexPath) as! RequestRideCell
            let post = requestedRides[indexPath.row]
            requestCell.destinationLabel.text = post.destination
            requestCell.fromLabel.text = post.from
            requestCell.timeLabel.text = post.pickUpTime.string(dateStyle: .long, timeStyle: .short)
            requestCell.creatorLabel.text = post.creatorDisplayName
            cell = requestCell as RequestRideCell
            
        case 1:  // offers
            let offerCell = tableView.dequeueReusableCell(withIdentifier: "OfferRideCell", for: indexPath) as! OfferRideCell
            let post = offeredRides[indexPath.row]
            offerCell.destinationLabel.text = post.destination
            offerCell.fromLabel.text = post.from
            offerCell.timeLabel.text = post.pickUpTime.string(dateStyle: .long, timeStyle: .short)
            offerCell.creatorLabel.text = post.creatorDisplayName
            cell = offerCell as OfferRideCell
        default:
            break
        }
        return cell
    }
}


