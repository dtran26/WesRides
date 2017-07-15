//
//  NewRideViewController.swift
//  WesRides
//
//  Created by Dan on 7/13/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import DateTimePicker

class NewRideViewController: UIViewController, UITextFieldDelegate{

    let locations = ["Wesleyan", "Bradley", "New Haven", "Boston", "New York City"]
    
    @IBOutlet weak var timeOutlet: UITextField!
    
    @IBOutlet weak var startLocationOutlet: UITextField!

    @IBOutlet weak var endLocationOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startLocationOutlet.delegate = self
        self.endLocationOutlet.delegate = self
        self.timeOutlet.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
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
        let datePicker = ActionSheetDatePicker(title: "DateAndTime:", datePickerMode: UIDatePickerMode.dateAndTime, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            if let value = value {
                sender.text = (value as AnyObject).debugDescription
            }
            
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
        datePicker?.minimumDate = Date(timeInterval: 0, since: Date())
        datePicker?.maximumDate = Date(timeInterval: secondsInWeek, since: Date())
        datePicker?.minuteInterval = 20
        datePicker?.show()
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
