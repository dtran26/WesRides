//
//  PostService.swift
//  WesRides
//
//  Created by Dan on 7/13/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import Foundation
import Firebase

class PostService{
    
    static func create(from startLocation: String, to endLocation: String, capacity: Int, time: Date, notes: String, isOffer: Bool) {
        // create new post in database
        let currentUser = Auth.auth().currentUser
        
        let name = currentUser?.displayName
        
        let post = Ride(from: startLocation, destination: endLocation, pickUpTime: time, notes: notes, capacity: capacity, creatorUID: (currentUser?.uid)!, creatorDisplayName: name!, offerNewRideBool: isOffer, creatorEmail: (currentUser?.email!)!)
        
        let dict = post.dictValue
        
        let postRef = Database.database().reference().child("posts").childByAutoId()
        let userRef = Database.database().reference().child("users").child((currentUser?.uid)!)
        
        userRef.updateChildValues(["lastPostTime" : dict["createdAt"]!])
    
        postRef.updateChildValues(dict) { (error, ref) in
            if error == nil {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "upload"), object: self)
            }
        }
        
    }
    
    
    
}
