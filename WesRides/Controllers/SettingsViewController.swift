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
            
            <<< TextRow("MessengerTag"){ row in
                row.hidden = Condition.function(["switchRowMessenger"], { form in
                    return !((form.rowBy(tag: "switchRowMessenger") as? SwitchRow)?.value ?? false)
                })
                row.title = "Messenger Username"
                row.value = defaults.string(forKey: "messengerUsername")
                row.placeholder = "Enter username here"
                
            }
            <<< ButtonRow(){ row in
                row.hidden = Condition.function(["switchRowMessenger"], { form in
                    return !((form.rowBy(tag: "switchRowMessenger") as? SwitchRow)?.value ?? false)
                })
                row.title = "How to find Messenger username"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.showMessengerAlert()
            }
            
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Schedule"
                row.presentationMode = .segueName(segueName: "settingsToSchedule", onDismiss: nil)
            }
            
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "About"
                row.presentationMode = .segueName(segueName: "settingsToAbout", onDismiss:nil)
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
        
        
        
        
        // Get value for switchPhone
        let phoneSelectionRow : SwitchRow? = form.rowBy(tag: "switchRowPhone")
        let phoneSelectionRowValue = phoneSelectionRow?.value
        
        
        // Get value for switchEmail
        
        let emailSelectionRow : SwitchRow? = form.rowBy(tag: "switchRowEmail")
        let emailSelectionRowValue = emailSelectionRow?.value
        
        
        // Get value for Phone #
        let phoneNumber : PhoneRow? = form.rowBy(tag: "PhoneNumberTag")
        let phoneNumberValue = phoneNumber?.value
        
        
        // Get value for switchMessenger
        
        let messengerSelectionRow : SwitchRow? = form.rowBy(tag: "switchRowMessenger")
        let messengerSelectionRowValue = messengerSelectionRow?.value
        
        
        // Get value for Messenger Username
        let messengerUsername : TextRow? = form.rowBy(tag: "MessengerTag")
        let messengerUsernameValue = messengerUsername?.value
        
        
        
        // Warning for at least one medium of communication
        if !phoneSelectionRowValue! && !emailSelectionRowValue! && !messengerSelectionRowValue!{
            
            warning.configureContent(title: "", body: "You need to have at least one medium of communication", iconText: iconText)
            SwiftMessages.show(config: warningConfig, view: warning)
            
        }
            
            
            // Proceed with saving data
        else{
            
            // Persistence using Userdefaults
            self.defaults.set(phoneSelectionRowValue, forKey: "switchRowPhoneSelection")
            self.defaults.set(emailSelectionRowValue, forKey: "switchRowEmailSelection")
            self.defaults.set(phoneNumberValue, forKey: "phoneNumber")
            self.defaults.set(messengerSelectionRowValue, forKey: "switchRowMessengerSelection")
            self.defaults.set(messengerUsernameValue, forKey: "messengerUsername")
            
            
            // Save phone # to DB
            
            switch phoneSelectionRowValue!{
            case true:
                guard let userPhoneNumber = phoneNumberValue,
                    userPhoneNumber.characters.count == 10
                    else {
                        warning.configureContent(title: "Invalid Phone Number", body: "Enter your number again", iconText: iconText)
                        SwiftMessages.show(config: warningConfig, view: warning)
                        return
                }
                view.endEditing(true)
                userRef.updateChildValues(["phoneNumber" : userPhoneNumber, "contactByPhone" : true])
            case false:
                userRef.updateChildValues(["contactByPhone" : false])
            }
            
            
            // Save email to DB
            
            switch emailSelectionRowValue!{
            case true:
                userRef.updateChildValues(["contactByEmail" : true])
            case false:
                userRef.updateChildValues(["contactByEmail" : false])
            }
            
            //Save messenger to DB
            
            switch messengerSelectionRowValue!{
            case true:
                guard let userMessengerUsername = messengerUsernameValue
                    else{
                        warning.configureContent(title: "Invalid Messenger Username", body: "Enter your username again", iconText: iconText)
                        SwiftMessages.show(config: warningConfig, view: warning)
                        return
                }
                view.endEditing(true)
                userRef.updateChildValues(["messengerUsername" : userMessengerUsername, "contactByMessenger" : true])
            case false:
                userRef.updateChildValues(["contactByMessenger" : false])
            }
            
            
            successNotification()
        }
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
    
    func showMessengerAlert(){
        let info = MessageView.viewFromNib(layout: .MessageView)
        info.configureTheme(.info)
        info.configureContent(title: nil, body: "1. Open Messenger App \n2. From Home, tap your profile picture in the top left corner \n3. Your username will be beneath your name", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "OK", buttonTapHandler: {_ in SwiftMessages.hide()})
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.duration = .forever
        infoConfig.presentationStyle = .bottom
        SwiftMessages.show(config: infoConfig, view: info)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // phone switch
        let phoneSelectionRow : SwitchRow? = form.rowBy(tag: "switchRowPhone")
        let phoneSelectionRowValue = phoneSelectionRow?.value
        // phone row
        let phoneNumber : PhoneRow? = form.rowBy(tag: "PhoneNumberTag")
        let phoneNumberValue = phoneNumber?.value
        
        if(phoneSelectionRowValue == true && phoneNumberValue == nil){
            self.defaults.set(false, forKey: "switchRowPhoneSelection")
        }
        
        // messenger switch
        let messengerSelectionRow : SwitchRow? = form.rowBy(tag: "switchRowMessenger")
        let messengerSelectionRowValue = messengerSelectionRow?.value
        // messenger row
        let messengerUsername : TextRow? = form.rowBy(tag: "MessengerTag")
        let messengerUsernameValue = messengerUsername?.value
        
        if(messengerSelectionRowValue == true && messengerUsernameValue == nil){
            self.defaults.set(false, forKey: "switchRowMessengerSelection")
        }
        view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
