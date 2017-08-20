//
//  AboutViewController.swift
//  WesRides
//
//  Created by DanSWRevealViewControllerSeguePushController on 8/6/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func feedbackButtonTapped(_ sender: UIButton) {
        sendFeedback()
    }
    
    
    @IBAction func rateTheApp(_ sender: UIButton) {
        let appID = "1268451024"
        if let checkURL = URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appID)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
            open(url: checkURL)
        } else {
            print("invalid url")
        }
    }
    
    func open(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
            print("Open \(url): \(success)")
            })
    }
    
}

extension AboutViewController : MFMailComposeViewControllerDelegate{
    
    func sendFeedback() {
        if !MFMailComposeViewController.canSendMail() {
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["dtran@wesleyan.edu"])
        composeVC.setSubject("WesRides Feedback")
        composeVC.setMessageBody("", isHTML: false)
        // present
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
