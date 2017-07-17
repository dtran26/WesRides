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
    
    static func create(from startLocation: String, to endLocation: String, capacity: String, time: Date, notes: String) {
        // create new post in database
        let currentUser = (Auth.auth().currentUser)!
        
        let post = Ride(from: startLocation, destination: endLocation, pickUpTime: time, notes: notes, capacity: capacity)
        
        let dict = post.dictValue
        
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        
        postRef.updateChildValues(dict)
        
    }
    
    
    
    
}
