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


class HomeViewController: UIViewController{
    
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
        switch rideSegmentedControl.selectedSegmentIndex {
        case 0:
            print("hello")
            //loadRequestedRides()
        case 1:
            print("hello2")
            //loadOfferedRides
        default:
            return
        }
        
    }
    
    
    func reloadTimeline() {
        switch rideSegmentedControl.selectedSegmentIndex{
        case 0: //requests
            UserService.posts(completion: { (requestrides, offerrides) in
                self.requestedRides = requestrides
                self.offeredRides = offerrides
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.tableView.reloadData()
            })
        case 1:  // offers
            UserService.posts(completion: { (requestrides, offerrides) in
                self.requestedRides = requestrides
                self.offeredRides = offerrides
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.tableView.reloadData()
            })
        default:
            return
        }

    }
    
    func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    
    @IBAction func newRideTapped(_ sender: Any) {
        performSegue(withIdentifier: "newRideSegue", sender: self)
    }
    
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier{
//            if identifier == "detailedRide"{
//                if let cell = sender as? UITableViewCell{
//                    let index = tableView.indexPath(for: cell)
//                    let ride = rides[index!.row]
//                    let detailedRideVC = segue.destination as! DetailedRideViewController
//                    detailedRideVC.detailedRide = ride
//                    
//                }
//            }
//        }
//    }
    
    
    
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
//        let post = rides[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestRideCell", for: indexPath) as! RequestRideCell
//        
//        cell.destinationLabel.text = post.destination
//        cell.fromLabel.text = post.from
//        cell.timeLabel.text = post.pickUpTime.string(dateStyle: .long, timeStyle: .short)
//        cell.creatorLabel.text = post.creatorDisplayName
//        
//        return cell
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

