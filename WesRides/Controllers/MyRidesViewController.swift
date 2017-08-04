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

    var requestedRides = [Ride]()
    var offeredRides = [Ride]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserService.posts(own: true) { (requestrides, offerrides) in
            self.requestedRides = requestrides
            self.offeredRides = offerrides
            self.tableView.reloadData()
        }
        configureTableView()
        
    }

    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        hideHairline()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        if section == 0 {
            return requestedRides.count
        }
        
        if section == 1 {
            return offeredRides.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var post : Ride?
        
        let myRideCell = tableView.dequeueReusableCell(withIdentifier: "MyRidesCell", for: indexPath)
            as! RideCell
        if indexPath.section == 0{
            post = requestedRides[indexPath.row]
        }
        if indexPath.section == 1{
            post = offeredRides[indexPath.row]
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


extension MyRidesViewController: HideableHairlineViewController{
}
