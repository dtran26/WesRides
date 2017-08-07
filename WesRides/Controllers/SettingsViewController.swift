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

class SettingsViewController: FormViewController {
    
    @IBOutlet weak var openMenu: UIBarButtonItem!
    
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu()
        
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
            
            <<< SwitchRow("switchRowTag2"){
                $0.title = "Email"
            }
            
            <<< SwitchRow("switchRowTag"){
                $0.title = "Text Message"
            }
            
            <<< PhoneRow(){
                $0.hidden = Condition.function(["switchRowTag"], { form in
                    return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Phone Number"
                $0.placeholder = "Enter phone number here"
                
                
        }
    }
    
        
        func sideMenu() {
            openMenu.target = self.revealViewController()
            openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
        
        
    }
