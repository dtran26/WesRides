//
//  Users.swift
//  WesRides
//
//  Created by Dan on 7/11/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import Foundation
import Firebase
//import FirebaseDatabase.FIRDataSnapshot

class User{
    
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var email : String
    var username : String
    let uid : String
    
    init(uid: String, username : String, email: String){
        self.uid = uid
        self.username = username
        self.email = email

    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String : Any],
              let username = dict["username"] as? String,
              let email = dict["userEmail"] as? String
            else{ return nil }
        self.uid = snapshot.key
        self.username = username
        self.email = email
    }
    

}
