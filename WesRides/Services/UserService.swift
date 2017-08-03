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
    
    static func posts(own: Bool, completion: @escaping ([Ride], [Ride]) -> Void) {

        let ref = Database.database().reference().child("posts")
        let currentUser = Auth.auth().currentUser
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([], [])
            }

            var posts = snapshot.flatMap(Ride.init)
            var postsOffered = snapshot.flatMap(Ride.init)
            
            if !own {
            posts = posts.filter({ (Ride) -> Bool in
                Ride.pickUpTime.isInFuture
            })
            postsOffered = postsOffered.filter({ (Ride) -> Bool in
                Ride.pickUpTime.isInFuture
            })
            
            }
            posts = posts.sorted(by: { (Ride1, Ride2) -> Bool in
                Ride1.pickUpTime < Ride2.pickUpTime
            })
            
            posts = posts.filter({ (Ride) -> Bool in
                Ride.offerNewRideBool == false
            })
            

            
            postsOffered = postsOffered.sorted(by: { (Ride1, Ride2) -> Bool in
                Ride1.pickUpTime < Ride2.pickUpTime
            })
            
            postsOffered = postsOffered.filter({ (Ride) -> Bool in
                Ride.offerNewRideBool == true
            })
            
            if own{
                posts = posts.filter({ (Ride) -> Bool in
                    Ride.creatorDisplayName == currentUser?.displayName
                })
                postsOffered = postsOffered.filter({ (Ride) -> Bool in
                    Ride.creatorDisplayName == currentUser?.displayName
                })
            }
            
            completion(posts, postsOffered)
            
        })
        
        
    }
    
    
    
    
    
    
    
    
    
}
