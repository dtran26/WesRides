//
//  UserService.swift
//  WesRides
//
//  Created by Dan on 7/12/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import Foundation
import Firebase

struct UserService {
    
    static func posts(completion: @escaping ([Ride]) -> Void) {

        let currentUser = (Auth.auth().currentUser)!
        let ref = Database.database().reference().child("posts").child(currentUser.uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }
            
            var posts = snapshot.flatMap(Ride.init)
            posts = posts.sorted(by: { (Ride1, Ride2) -> Bool in
                Ride1.pickUpTime < Ride2.pickUpTime
            })
            
            completion(posts)
            
        })
    }
    
    
    
    
    
    
    
    
    
}
