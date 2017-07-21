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
import SCLAlertView

class NewRideViewController: UIViewController{

    let locations = ["Wesleyan", "Bradley", "New Haven", "Boston", "New York City"]
    
    var chosenTime = Date()
    
    @IBOutlet weak var timeOutlet: UITextField!
    
    @IBOutlet weak var startLocationOutlet: UITextField!

    @IBOutlet weak var endLocationOutlet: UITextField!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var capacity: UILabel!
    
    @IBOutlet weak var notes: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegates()
        stepperSetUp()
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewRideViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func setTextFieldDelegates(){
        self.startLocationOutlet.delegate = self
        self.endLocationOutlet.delegate = self
        self.timeOutlet.delegate = self
    }
    
    func stepperSetUp(){
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 7
        stepper.minimumValue = 1
    }

    @IBAction func startLocationTapped(_ sender: UITextField) {
        ActionSheetStringPicker.show(withTitle: "Choose Start Location", rows: locations, initialSelection: 0, doneBlock: {
            picker, value, index in
            sender.text = self.locations[value]
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
        
    }
    
    
    @IBAction func endLocationTapped(_ sender: UITextField) {
        ActionSheetStringPicker.show(withTitle: "Choose End Location", rows: locations, initialSelection: 0, doneBlock: {
            picker, value, index in
            sender.text = self.locations[value]
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func timeTapped(_ sender: UITextField) {
        let datePicker = ActionSheetDatePicker(title: "Pick Ride Time:", datePickerMode: UIDatePickerMode.dateAndTime, selectedDate: Date(), doneBlock: {
            picker, value, index in
                if let value = value {
                    sender.text = (value as! Date).string(dateStyle: .medium, timeStyle: .short)
                    self.chosenTime = value as! Date
                    print(self.chosenTime)
                }
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!)
        datePicker?.minimumDate = Date(timeInterval: 0, since: Date())
        datePicker?.minuteInterval = 20
        datePicker?.show()
    }
    

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        capacity.text = Int(sender.value).description
    }
    
    
    
    @IBAction func saveNewRide(_ sender: UIBarButtonItem) {
        if (startLocationOutlet.text?.isEmpty)! || (endLocationOutlet.text?.isEmpty)!{
            SCLAlertView().showError("Error", subTitle: "Fill in all the fields") // Error
        }
        else{
            PostService.create(from: startLocationOutlet.text!, to: endLocationOutlet.text!, capacity: capacity.text!, time: chosenTime, notes: notes.text!)
            performSegue(withIdentifier: "unwindToHome", sender: self)
        }
        
    }


}


extension NewRideViewController : UITextFieldDelegate {
    
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

