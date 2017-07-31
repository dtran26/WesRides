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
    
    @IBOutlet weak var joinButton: UIButton!
    
    var detailedRide : Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromOutlet.text = detailedRide?.from
        destinationOutlet.text = detailedRide?.destination
        timeOutlet.text = detailedRide?.pickUpTime.string(dateStyle: .long, timeStyle: .short)
        print(String(describing: detailedRide!.capacity))
        capacityOutlet.text = String(describing: detailedRide!.capacity)
        if (detailedRide?.offerNewRideBool)!{
            seatRequiredOrAvailable.text = "Available"
        }
        else if !(detailedRide?.offerNewRideBool)!{
            seatRequiredOrAvailable.text = "Required"
        }
        
        if !(detailedRide?.offerNewRideBool)!{
            joinButton.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
