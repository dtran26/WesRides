//
//  ViewController.swift
//  WesRides
//
//  Created by Dan on 7/13/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import DropDown

class FilterViewController: UIViewController {
    
    var requestedRidesFiltered = [Ride]()
    var offererRidesFiltered = [Ride]()
    let chooseFromDropDown = DropDown()
    let chooseDestinationDropDown = DropDown()
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var destinationButton: UIButton!
    let locations = [
        "Wesleyan",
        "Bradley",
        "New Haven",
        "Boston",
        "New York City"
    ]
    
    @IBAction func searchTapped(_ sender: UIButton) {

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDowns()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func chooseFrom(_ sender: Any) {
        chooseFromDropDown.show()
    }
    
    
    @IBAction func choseDestination(_ sender: Any) {
        chooseDestinationDropDown.show()
    }
    
    func setupDropDowns(){
        setupChooseFromDropDown()
        setupChooseDestinationDropDown()
    }

    func setupChooseFromDropDown(){
        chooseFromDropDown.anchorView = fromButton
        chooseFromDropDown.bottomOffset = CGPoint(x: 0, y: fromButton.bounds.height)
        chooseFromDropDown.dataSource = locations
        chooseFromDropDown.selectionAction = { [unowned self] (index, item) in
            self.fromButton.setTitle(item, for: .normal)
        }
    }
    
    func setupChooseDestinationDropDown(){
        chooseDestinationDropDown.anchorView = destinationButton
        chooseDestinationDropDown.bottomOffset = CGPoint(x: 0, y: destinationButton.bounds.height)
        chooseDestinationDropDown.dataSource = locations
        chooseDestinationDropDown.selectionAction = { [unowned self] (index, item) in
            self.destinationButton.setTitle(item, for: .normal)
        }
    }




     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     }
    
    
}
