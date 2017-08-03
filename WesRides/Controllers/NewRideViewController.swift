//
//  NewRideViewController.swift
//  WesRides
//
//  Created by Dan on 7/13/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SwiftDate
import FirebaseAuth
import FirebaseDatabase
import SwiftMessages

class NewRideViewController: UIViewController{
    
    let locations = ["Wesleyan", "Bradley", "New Haven", "Boston", "New York City"]
    var chosenTime = Date()
    var isRideOffer : Bool?
    @IBOutlet weak var requestOrOfferRide: UISegmentedControl!
    @IBOutlet weak var timeOutlet: UITextField!
    @IBOutlet weak var startLocationOutlet: UITextField!
    @IBOutlet weak var endLocationOutlet: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var capacity: UITextField!
    @IBOutlet weak var notes: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegates()
        stepperSetUp()
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewRideViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)


        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setTextFieldDelegates(){
        self.startLocationOutlet.delegate = self
        self.endLocationOutlet.delegate = self
        self.timeOutlet.delegate = self
        self.capacity.delegate = self
    }
    
    func stepperSetUp(){
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 7
        stepper.minimumValue = 0
    }
    
    @IBAction func startLocationTapped(_ sender: UITextField) {
        self.view.endEditing(true)
        ActionSheetStringPicker.show(withTitle: "Choose Start Location", rows: locations, initialSelection: 0, doneBlock: {
            picker, value, index in
            sender.text = self.locations[value]
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    
    @IBAction func endLocationTapped(_ sender: UITextField) {
        self.view.endEditing(true)
        ActionSheetStringPicker.show(withTitle: "Choose End Location", rows: locations, initialSelection: 0, doneBlock: {
            picker, value, index in
            sender.text = self.locations[value]
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func timeTapped(_ sender: UITextField) {
        self.view.endEditing(true)
        let datePicker = ActionSheetDatePicker(title: "Pick Ride Time:", datePickerMode: UIDatePickerMode.dateAndTime, selectedDate: Date(timeInterval: 3600, since: Date()), doneBlock: {
            picker, value, index in
            if let value = value {
                sender.text = (value as! Date).string(dateStyle: .medium, timeStyle: .short)
                self.chosenTime = value as! Date
            }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!)
        let secondsInThreeWeek: TimeInterval = 7 * 24 * 60 * 60 * 3
        let secondsInAnHour : TimeInterval = 60 * 60
        datePicker?.minimumDate = Date(timeInterval: secondsInAnHour, since: Date())
        datePicker?.maximumDate = Date(timeInterval: secondsInThreeWeek, since: Date())
        datePicker?.minuteInterval = 10
        datePicker?.show()
    }
    
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        capacity.text = Int(sender.value).description
    }
    
    @IBAction func didCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let dispatch = DispatchGroup()
    
    @IBAction func saveNewRide(_ sender: UIBarButtonItem) {
        var timeInterval : TimeInterval?
        
        let currentUser = (Auth.auth().currentUser)!
        let userRef = Database.database().reference().child("users").child(currentUser.uid)
        dispatch.enter()
        
        userRef.observe(DataEventType.value, with: { (snapshot) in
            
            let userDict = snapshot.value as? [String : AnyObject] ?? [:]
            let lastPostTime = userDict["lastPostTime"]!
            let userLastPostedAt = Date(timeIntervalSince1970: lastPostTime as! TimeInterval)
            let currentTime = Date()
            timeInterval = currentTime.timeIntervalSince(userLastPostedAt)
            self.dispatch.leave()
        })
        
        
        // WARNING SET UP
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        warning.button?.isHidden = true
        let iconText = ["🤔", "😖", "🙄", "😶", "😩", "😰"].sm_random()!
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        
        
        dispatch.notify(queue: .main) {
            if (timeInterval! < TimeInterval(30.0)) {
                warning.configureContent(title: "You are posting too much", body: "Chill out", iconText: iconText)
                SwiftMessages.show(config: warningConfig, view: warning)
            }
        }
        
        
        if (startLocationOutlet.text?.isEmpty)! || (endLocationOutlet.text?.isEmpty)! || (timeOutlet.text?.isEmpty)! || capacity.text == ""{
            warning.configureContent(title: "Fill in all the required fields", body: "", iconText: iconText)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
            
        else if (startLocationOutlet.text == endLocationOutlet.text) {
            warning.configureContent(title: "Change Destination Point", body: "", iconText: iconText)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
            
        else if (capacity.text! == "0") {
            warning.configureContent(title: "Capacity cannot be zero", body: "", iconText: iconText)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
    
        else{
            switch requestOrOfferRide.selectedSegmentIndex{
            case 0:
                isRideOffer = false
            case 1:
                isRideOffer = true
            default:
                return
            }
            let view = MessageView.viewFromNib(layout: .CenteredView)
            var config = SwiftMessages.Config()
            view.configureTheme(.info)
            view.configureDropShadow()
            view.configureContent(title: "Confirm Ride Details", body: "From: \(startLocationOutlet.text!) \nTo: \(endLocationOutlet.text!) \nWhen: \(timeOutlet.text!)", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK 👌"
                , buttonTapHandler: { _ in
                    PostService.create(from: self.startLocationOutlet.text!, to: self.endLocationOutlet.text!, capacity: Int(self.capacity.text!)!, time: self.chosenTime, notes: self.notes.text!, isOffer: self.isRideOffer!)
                    SwiftMessages.hide()
                    self.performSegue(withIdentifier: "unwindToHome", sender: nil)
                    let status = MessageView.viewFromNib(layout: .StatusLine)
                    status.backgroundView.backgroundColor = UIColor(red:0.29, green:0.71, blue:0.26, alpha:1.0)
                    status.bodyLabel?.textColor = UIColor.white
                    status.configureContent(body: "Ride Successfuly Created")
                    var statusConfig = SwiftMessages.defaultConfig
                    statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                    SwiftMessages.show(config: statusConfig, view: status)
            })
            config.presentationStyle = .center
            config.duration = .forever
            config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
            config.presentationContext  = .window(windowLevel: UIWindowLevelStatusBar)
            SwiftMessages.show(config: config, view: view)
            
        }
        
    }
    
    
}


extension NewRideViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

extension NewRideViewController: UITextViewDelegate{
    
    
}
