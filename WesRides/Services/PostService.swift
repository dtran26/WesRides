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
    
    private static var postCount = 0
    private static let currentUser = Auth.auth().currentUser
    private static let userRef = Database.database().reference().child("users").child((currentUser?.uid)!)
    private static let postRef = Database.database().reference().child("posts")
    
    
    static func create(from startLocation: String, to endLocation: String, capacity: Int, time: Date, notes: String, isOffer: Bool) {
        // create new post in database
        let name = currentUser?.displayName
        let post = Ride(from: startLocation, destination: endLocation, pickUpTime: time, notes: notes, capacity: capacity, creatorUID: (currentUser?.uid)!, creatorDisplayName: name!, offerNewRideBool: isOffer, creatorEmail: (currentUser?.email!)!)
        
        let dict = post.dictValue

        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as? [String : Any] ?? [:]
            let currentPostCount = userDict["postCount"] as! Int
            postCount = currentPostCount + 1
            print("User's current postCount: \(postCount)")
            userRef.updateChildValues(["postCount" : postCount])
        })
        
        userRef.updateChildValues(["lastPostTime" : dict["createdAt"]!])
        postRef.childByAutoId().updateChildValues(dict) { (error, ref) in
            if error == nil {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "upload"), object: self)
                print("Post successfull")
            }
            else{
                print(error ?? "Post not successfull")
            }
        }
        
    }
    
    static func delete(_ post: Ride){
        postRef.child((post.key)!).removeValue(completionBlock: { (error, refer) in
            if error != nil {
                print(error!)
            } else {
                print(refer)
                print("Post Removed Correctly")
            }
            
        })
        
        userRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let userDict = snapshot.value as? [String : Any] ?? [:]
            let currentPostCount = userDict["postCount"] as! Int
            postCount = currentPostCount - 1
            print("User's current postCount: \(currentPostCount)")
            print("User's new postCount: \(postCount)")
            userRef.updateChildValues(["postCount" : postCount])
        })
        

        
    }
    
    
}
