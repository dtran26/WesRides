//
//  SettingsViewController.swift
//  WesRides
//
//  Created by Dan on 8/6/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth
import FirebaseDatabase
import SwiftMessages

class SettingsViewController: FormViewController {
    
    @IBOutlet weak var openMenu: UIBarButtonItem!
    
    let currentUser = Auth.auth().currentUser
    let defaults : UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.register(defaults: ["phoneSwitchKey" : false])
        
        form +++ Section()
            <<< TextRow(){ row in
                row.title = "Name"
                row.value = currentUser?.displayName!
                row.disabled = true
            }
            
            <<< TextRow(){ row in
                row.title = "Email"
                row.value = currentUser?.email
                row.disabled = true
            }
            
            +++ Section("How do you want to be contacted?")
            
            <<< SwitchRow("switchRowEmail"){
                $0.title = "Email"
                $0.value = defaults.bool(forKey: "switchRowEmailSelection")
            }
            
            <<< SwitchRow("switchRowPhone"){
                $0.title = "Text Message"
                $0.value = defaults.bool(forKey: "switchRowPhoneSelection")
            }
            
            <<< PhoneRow("PhoneNumberTag"){
                $0.hidden = Condition.function(["switchRowPhone"], { form in
                    return !((form.rowBy(tag: "switchRowPhone") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Phone Number"
                $0.placeholder = "Enter phone number here"
                
                
        }
    }

    
    @IBAction func saveSettings(_ sender: UIBarButtonItem) {
        // Persistence for switchPhone
        let phoneSelectionRow : SwitchRow? = form.rowBy(tag: "switchRowPhone")
        let phoneSelectionRowValue = phoneSelectionRow?.value
        self.defaults.set(phoneSelectionRowValue, forKey: "switchRowPhoneSelection")
        
        // Persistence for switchEmail
        
        let emailSelectionRow : SwitchRow? = form.rowBy(tag: "switchRowEmail")
        let emailSelectionRowValue = phoneSelectionRow?.value
        self.defaults.set(phoneSelectionRowValue, forKey: "switchRowEmailSelection")
        
        // Save phone # to DB
        
        let phoneRow : PhoneRow? = form.rowBy(tag: "PhoneNumberTag")
        let phoneRowValue = phoneRow?.value
        guard phoneRowValue != nil else {
            return
        }
        let userRef = Database.database().reference().child("users").child((currentUser?.uid)!)
        userRef.updateChildValues(["phoneNumber" : phoneRowValue!])
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

        
        
    }
