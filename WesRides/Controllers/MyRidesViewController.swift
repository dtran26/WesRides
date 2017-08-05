//
//  MyRidesViewController.swift
//  WesRides
//
//  Created by Dan on 8/1/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MyRidesViewController: UIViewController {

    let refreshControl = UIRefreshControl()
    var requestedRides = [Ride]()
    var offeredRides = [Ride]()
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    @IBOutlet weak var openMenu: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTimeline()
        configureTableView()
        sideMenu()
    }

    func sideMenu() {
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if(cellStyleForEditing == .none) {
            cellStyleForEditing = .delete
        } else {
            cellStyleForEditing = .none
        }
        tableView.setEditing(cellStyleForEditing != .none, animated: true)
    }
    
    func reloadTimeline() {
        let delayTime = DispatchTime.now() + Double(Int64(1.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        UserService.posts(own: true, completion: { (requestrides, offerrides) in
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

    
}



extension MyRidesViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Your requested rides"
        }
        
        else{
            return "Your offered rides"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section{
        case 0:
            return requestedRides.count
        case 1:
            return offeredRides.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var post : Ride?
        let myRideCell = tableView.dequeueReusableCell(withIdentifier: "MyRideCell", for: indexPath) as! RideCell
        
        switch indexPath.section{
        case 0:
            post = requestedRides[indexPath.row]
        case 1:
            post = offeredRides[indexPath.row]
        default:
            break
        }
        
        myRideCell.destinationLabel.text = post?.destination
        myRideCell.fromLabel.text = post?.from
        myRideCell.timeLabel.text = post?.pickUpTime.string(dateStyle: .long, timeStyle: .short)
        myRideCell.creatorLabel.text = post?.creatorDisplayName
        
        return myRideCell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 0{
                requestedRides.remove(at: indexPath.row)
            }
            if indexPath.section == 1{
                offeredRides.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}

extension MyRidesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let str = "No Rides Found 😔"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
}



