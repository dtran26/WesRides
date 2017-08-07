//
//  AboutViewController.swift
//  WesRides
//
//  Created by Dan on 8/6/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var openMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        
    }

    func sideMenu() {
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
