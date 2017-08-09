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
        defaults.register(defaults: ["phoneNumber" : ""])
        
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
                $0.value = defaults.string(forKey: "phoneNumber")
            }
            
            <<< SwitchRow("switchRowMessenger"){
                $0.title = "FB Messenger"
                $0.value = defaults.bool(forKey: "switchRowMessengerSelection")
            }
        
            <<< TextRow(){ row in
                row.hidden = Condition.function(["switchRowMessenger"], { form in
                    return !((form.rowBy(tag: "switchRowMessenger") as? SwitchRow)?.value ?? false)
                })
                row.title = "Messenger Username"
                row.value = defaults.string(forKey: "MessengerUsername")
                row.placeholder = "m.me/yourusername"
        }
    }
    
    
    @IBAction func saveSettings(_ sender: UIBarButtonItem) {
        let userRef = Database.database().reference().child("users").child((currentUser?.uid)!)
        
        //SwiftMessages Set Up
        let warning = MessageView.viewFromNib(layout: .CardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        warning.button?.isHidden = true
        let iconText = ["🤔", "😖", "🙄", "😶", "😔", "😰"].sm_random()!
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        warning.configureContent(title: "Invalid Phone Number", body: "Enter your number again", iconText: iconText)
        
        // Persistence for switchPhone
        let phoneSelectionRow : SwitchRow? = form.rowBy(tag: "switchRowPhone")
        let phoneSelectionRowValue = phoneSelectionRow?.value
        self.defaults.set(phoneSelectionRowValue, forKey: "switchRowPhoneSelection")
        
        // Persistence for switchEmail
        
        let emailSelectionRow : SwitchRow? = form.rowBy(tag: "switchRowEmail")
        let emailSelectionRowValue = emailSelectionRow?.value
        self.defaults.set(emailSelectionRowValue, forKey: "switchRowEmailSelection")
        
        // Persistence for Phone #
        let phoneNumber : PhoneRow? = form.rowBy(tag: "PhoneNumberTag")
        let phoneNumberValue = phoneNumber?.value
        self.defaults.set(phoneNumberValue, forKey: "phoneNumber")
        
        
        // Save phone # to DB
        
        
        switch phoneSelectionRowValue!{
        case true:
            guard let userPhoneNumber = phoneNumberValue,
                userPhoneNumber.characters.count == 10
                else {
                    SwiftMessages.show(config: warningConfig, view: warning)
                    return
            }
            view.endEditing(true)
            userRef.updateChildValues(["phoneNumber" : phoneNumberValue!, "contactByPhone" : true])
        case false:
            userRef.updateChildValues(["contactByPhone" : false])

        }
        
        switch emailSelectionRowValue!{
        case true:
            userRef.updateChildValues(["contactByEmail" : true])
            print("hello")
        case false:
            userRef.updateChildValues(["contactByEmail" : false])
            print("goodbye")
        }
        
        successNotification()
        
    }
    
    
    func successNotification(){
        let delayTime = DispatchTime.now() + Double(Int64(1.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        let status = MessageView.viewFromNib(layout: .StatusLine)
        status.backgroundView.backgroundColor = UIColor(red:0.29, green:0.71, blue:0.26, alpha:1.0)
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: "Settings Successfuly Updated")
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        SwiftMessages.show(config: statusConfig, view: status)

    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
