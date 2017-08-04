//
//  DetailedRideViewController.swift
//  WesRides
//
//  Created by Dan on 7/20/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit

class DetailedRideViewController: UIViewController {
    
    @IBOutlet weak var fromOutlet: UILabel!
    @IBOutlet weak var destinationOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var capacityOutlet: UILabel!
    @IBOutlet weak var seatRequiredOrAvailable: UILabel!
    @IBOutlet weak var creatorOutlet: UILabel!
    var detailedRide : Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromOutlet.text = detailedRide?.from
        destinationOutlet.text = detailedRide?.destination
        timeOutlet.text = detailedRide?.pickUpTime.string(dateStyle: .long, timeStyle: .short)
        capacityOutlet.text = String(describing: detailedRide!.capacity)
        creatorOutlet.text = detailedRide?.creatorDisplayName
        if (detailedRide?.offerNewRideBool)!{
            seatRequiredOrAvailable.text = "Available"
        }
        else if !(detailedRide?.offerNewRideBool)!{
            seatRequiredOrAvailable.text = "Required"
        }
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
 


    
    
}
