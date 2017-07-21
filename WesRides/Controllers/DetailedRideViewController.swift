//
//  DetailedRideViewController.swift
//  WesRides
//
//  Created by Dan on 7/20/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit

class DetailedRideViewController: UIViewController {

    @IBOutlet weak var notesOutlet: UILabel!
    
    var detailedRide : Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesOutlet.text = detailedRide?.notes
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
