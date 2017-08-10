//
//  DetailedRideViewController.swift
//  WesRides
//
//  Created by Dan on 7/20/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MessageUI

class DetailedRideViewController: UIViewController {
    
    @IBOutlet weak var fromOutlet: UILabel!
    @IBOutlet weak var destinationOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var capacityOutlet: UILabel!
    @IBOutlet weak var seatRequiredOrAvailable: UILabel!
    @IBOutlet weak var creatorOutlet: UILabel!
    @IBOutlet weak var notesOutlet: UILabel!
    var detailedRide : Ride?
    var contactByPhone : Bool?
    var contactByEmail : Bool?
    var contactByMessenger : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rideDetailsSetUp()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkContactMethods()
    }
    
    func rideDetailsSetUp() {
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
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkContactMethods(){
        let creatorUID = (detailedRide?.creatorUID)!
        let userRef = Database.database().reference().child("users").child(creatorUID)
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            let userDict = snapshot.value as? [String : Any] ?? [:]
            self.contactByPhone = userDict["contactByPhone"] as? Bool
            self.contactByEmail = userDict["contactByEmail"] as? Bool
            self.contactByMessenger = userDict["contactByMessenger"] as? Bool
        })
        
    }
    
    
    func openUrl(urlString:String!) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func contactButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "How do you want to contact this person?", preferredStyle: .actionSheet)
        
        if (contactByPhone)!{
            let contactByPhone = UIAlertAction(title: "SMS", style: .default, handler: { action in
                self.sendSMS()
            })
            
            alertController.addAction(contactByPhone)
        }
        
        if (contactByMessenger)!{
            let contactByMessenger = UIAlertAction(title: "FB Messenger", style: .default, handler: { action in
                let url = (self.detailedRide?.creatorMessengerUsername)!
                print(url)
                self.openUrl(urlString: "http://www.m.me/\(url)")
            })
            alertController.addAction(contactByMessenger)
        }
        
        if (contactByEmail)!{
            let contactByPhone = UIAlertAction(title: "Email", style: .default, handler: { action in
                
                self.sendEmail()
                
            })
            alertController.addAction(contactByPhone)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        
    }
    
    
}



extension DetailedRideViewController : MFMailComposeViewControllerDelegate{
    
    func sendEmail() {
        if !MFMailComposeViewController.canSendMail() {
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients([(self.detailedRide?.creatorEmail)!])
        composeVC.setSubject("Your WesRides post")
        composeVC.setMessageBody("", isHTML: false)
        // present
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailedRideViewController : MFMessageComposeViewControllerDelegate{
    
    func sendSMS(){
        
        if MFMessageComposeViewController.canSendText() == true{
            print(detailedRide?.creatorPhoneNumber)
            let recipients:[String] = [(detailedRide?.creatorPhoneNumber)!]
            let messageController = MFMessageComposeViewController()
            messageController.messageComposeDelegate  = self // implement delegate if you want
            messageController.recipients = recipients
            messageController.subject = "Your WesRides post"
            messageController.body = ""
            self.present(messageController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
