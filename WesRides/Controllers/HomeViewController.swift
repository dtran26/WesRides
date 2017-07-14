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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var openMenu: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sideMenu()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sideMenu() {
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    @IBAction func newRideTapped(_ sender: Any) {
        performSegue(withIdentifier: "newRideSegue", sender: self)
        
    }
    
    

}

