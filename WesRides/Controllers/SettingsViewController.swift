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

class SettingsViewController: FormViewController {
    
    @IBOutlet weak var openMenu: UIBarButtonItem!
    
    let currentUser = Auth.auth().currentUser
    let defaults : UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.register(defaults: ["phoneSwitchKey" : false])
        
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
                $0.value = UserDefaults.bool(forKey: emailSwitchKey)
            }
            
            <<< SwitchRow("switchRowPhone"){
                $0.title = "Text Message"
                $0.value = UserDefaults.bool(forKey: phoneSwitchKey)
            }
            .onChange({ (SwitchRow) in
                UserDefaults.set(SwitchRow.value!, forKey: phoneSwitchKey)
            })
            
            <<< PhoneRow("PhoneNumberTag"){
                $0.hidden = Condition.function(["switchRowPhone"], { form in
                    return !((form.rowBy(tag: "switchRowPhone") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Phone Number"
                $0.placeholder = "Enter phone number here"
                
                
        }
    }

    
    @IBAction func saveSettings(_ sender: UIBarButtonItem) {
        let userRef = Database.database().reference().child("users").child((currentUser?.uid)!)
        let row : PhoneRow? = form.rowBy(tag: "PhoneNumberTag")
        let value = row?.value
        userRef.updateChildValues(["phoneNumber" : value!])
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

        
        
    }
