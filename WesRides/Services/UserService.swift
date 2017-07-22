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
    
    static func posts(completion: @escaping ([Ride], [Ride]) -> Void) {

        let ref = Database.database().reference().child("posts")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([], [])
            }

            var posts = snapshot.flatMap(Ride.init)
            var postsOffered = snapshot.flatMap(Ride.init)
            
            posts = posts.filter({ (Ride) -> Bool in
                Ride.pickUpTime.isInFuture
            })
            
            posts = posts.sorted(by: { (Ride1, Ride2) -> Bool in
                Ride1.pickUpTime < Ride2.pickUpTime
            })
            
            posts = posts.filter({ (Ride) -> Bool in
                Ride.offerNewRideBool == false
            })
            
            postsOffered = postsOffered.filter({ (Ride) -> Bool in
                Ride.pickUpTime.isInFuture
            })
            
            postsOffered = postsOffered.sorted(by: { (Ride1, Ride2) -> Bool in
                Ride1.pickUpTime < Ride2.pickUpTime
            })
            
            postsOffered = postsOffered.filter({ (Ride) -> Bool in
                Ride.offerNewRideBool == true
            })
            
            completion(posts, postsOffered)
            
        })
        
        
    }
    
    
    
    
    
    
    
    
    
}
