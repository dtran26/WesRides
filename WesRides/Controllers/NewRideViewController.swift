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
    var postCount : Int?
    var isRideOffer : Bool?
    var phoneNumber : String?
    var messengerUsername : String?

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
        tapTopDismissKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let currentUser = Auth.auth().currentUser
        let userRef = Database.database().reference().child("users").child((currentUser?.uid)!)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as? [String : Any] ?? [:]
            self.postCount = userDict["postCount"] as? Int
            self.messengerUsername = userDict["messengerUsername"] as? String
            self.phoneNumber = userDict["phoneNumber"] as? String
        })
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func tapTopDismissKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewRideViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func setTextFieldDelegates(){
        self.startLocationOutlet.delegate = self
        self.endLocationOutlet.delegate = self
        self.timeOutlet.delegate = self
        self.capacity.delegate = self
        self.notes.delegate = self
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
    
    
    func successNotification(){
        let status = MessageView.viewFromNib(layout: .StatusLine)
        status.backgroundView.backgroundColor = UIColor(red:0.29, green:0.71, blue:0.26, alpha:1.0)
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: "Ride Successfuly Created")
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: statusConfig, view: status)

    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func saveNewRide(_ sender: UIBarButtonItem) {
        print(postCount!)

        // WARNING SET UP
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        warning.button?.isHidden = true
        let iconText = ["🤔", "😖", "🙄", "😶", "😔", "😰"].sm_random()!
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        
        //WARNING ONE
        if (postCount! > 3){
            warning.configureContent(title: "You have reached your post limit", body: "Delete old rides before posting new ones", iconText: iconText)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
        
        //WARNING TWO
        else if (startLocationOutlet.text?.isEmpty)! || (endLocationOutlet.text?.isEmpty)! || (timeOutlet.text?.isEmpty)! || capacity.text == ""{
            warning.configureContent(title: "Fill in all the required fields", body: "", iconText: iconText)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
        
        //WARNING THREE
        else if (startLocationOutlet.text == endLocationOutlet.text) {
            warning.configureContent(title: "Change Destination Point", body: "", iconText: iconText)
            SwiftMessages.show(config: warningConfig, view: warning)
        }
          
        //WARNING FOUR
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
                    PostService.create(from: self.startLocationOutlet.text!, to: self.endLocationOutlet.text!, capacity: Int(self.capacity.text!)!, time: self.chosenTime, notes: self.notes.text!, isOffer: self.isRideOffer!, phoneNumber: self.phoneNumber!, messengerUsername: self.messengerUsername!)
                    
                    SwiftMessages.hide()
                    
                    self.performSegue(withIdentifier: "unwindToHome", sender: nil)
                    self.successNotification()
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 120
    }
    
}
