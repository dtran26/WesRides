//
//  RevealViewController.swift
//  WesRides
//
//  Created by Dan on 8/9/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit

class RevealViewController: SWRevealViewController, SWRevealViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        self.rearViewRevealOverdraw = 0.0
        
        self.tapGestureRecognizer()
        self.panGestureRecognizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - SWReveal view controller delegate
    
    func revealControllerPanGestureShouldBegin(_ revealController: SWRevealViewController!) -> Bool {
        let nc = revealController.frontViewController as! UINavigationController
        let vc = nc.topViewController
        if vc is SettingsViewController {
            return false
        }
        return true
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == .right {
            revealController.frontViewController.view.alpha = 0.75
            revealController.frontViewController.view.isUserInteractionEnabled = false
        }
        else {
            revealController.frontViewController.view.alpha = 1.0
            revealController.frontViewController.view.isUserInteractionEnabled = true
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, panGestureMovedToLocation location: CGFloat, progress: CGFloat, overProgress: CGFloat) {
        revealController.frontViewController.view.alpha = 1.0 - (progress * 0.25)
    }
}
