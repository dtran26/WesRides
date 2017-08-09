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
    @IBOutlet weak var notesOutlet: UILabel!

    @IBOutlet weak var messengerOutlet: UILabel!
    
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
        notesOutlet.text = "Notes: \(detailedRide!.notes)"
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClicLabel(sender:)))
//        messengerOutlet.isUserInteractionEnabled = true
//        messengerOutlet.addGestureRecognizer(tap)
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
 
    
    func onClicLabel(sender:UITapGestureRecognizer) {
        openUrl(urlString: "http://www.m.me/davidliangg")
    }
    
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }


    
    
}
