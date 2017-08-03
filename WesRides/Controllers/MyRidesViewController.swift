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
        var cell = UITableViewCell()
        
        if indexPath.section == 0{
            let myRequestCell = tableView.dequeueReusableCell(withIdentifier: "MyRidesRequested", for: indexPath)
            as! RideCell
            let post = requestedRides[indexPath.row]
            myRequestCell.destinationLabel.text = post.destination
            myRequestCell.fromLabel.text = post.from
            myRequestCell.timeLabel.text = post.pickUpTime.string(dateStyle: .long, timeStyle: .short)
            myRequestCell.creatorLabel.text = post.creatorDisplayName
            cell = myRequestCell as RideCell
        }

        if indexPath.section == 1{
            let myOfferCell = tableView.dequeueReusableCell(withIdentifier: "MyRidesOffered", for: indexPath) as! RideCell
            let post = offeredRides[indexPath.row]
            myOfferCell.destinationLabel.text = post.destination
            myOfferCell.fromLabel.text = post.from
            myOfferCell.timeLabel.text = post.pickUpTime.string(dateStyle: .long, timeStyle: .short)
            myOfferCell.creatorLabel.text = post.creatorDisplayName
            cell = myOfferCell as RideCell
        }
        
        return cell
        
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
