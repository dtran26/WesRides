//
//  Ride.swift
//  WesRides
//
//  Created by Dan on 7/13/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import Foundation


class Ride {
    
    var key: String?
    var rider: User?
    var fullname : String
    var email = ""
    var from = ""
    var destination = ""
    var pickUpTime = ""
    var notes = ""
    var postedTime = ""
    var capacity = ""
    var riders:[User]?
    var postId = ""
    
    init(rider:User, from:String, destination:String, pickUpTime: String, notes:String, postedTime: String, capacity: String, startingCapacity:String, postId:String)
    {
        self.rider = rider
        self.fullname = rider.fullName
        self.email = rider.email
        self.from = from
        self.destination = destination
        self.postedTime = postedTime
        self.pickUpTime = pickUpTime
        self.capacity = capacity
        self.notes = notes
        self.postId = postId
        
    }
    
    func addRider(_ rider: User){
        self.riders?.append(rider)
    }

    
    
    
}
