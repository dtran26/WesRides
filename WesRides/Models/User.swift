//
//  Users.swift
//  WesRides
//
//  Created by Dan on 7/11/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User{
    
    let fullName : String
    let email : String
    let uid : String
    var lastPostTime : Date?
    var postCount = 0
    var phoneNumber : String?
    
    init(uid: String, email: String, fullName : String){
        self.uid = uid
        self.email = email
        self.fullName = fullName

    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String : Any],
              let email = dict["userEmail"] as? String,
              let fullName = dict["fullName"] as? String,
              let postCount = dict["postCount"] as? Int
            else{ return nil }
        self.uid = snapshot.key
        self.email = email
        self.fullName = fullName
        self.postCount = postCount
    }
    

}
