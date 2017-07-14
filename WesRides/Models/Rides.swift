//
//  Rides.swift
//  WesRides
//
//  Created by Dan on 7/13/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import Foundation


class Rides {
    
    var key: String?
    var driver: User?
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var email = ""
    var fromStreetAddress = ""
    var fromCity = ""
    var fromState = ""
    var fromZipCode = ""
    var toStreetAddress = ""
    var toCity = ""
    var toState = ""
    var toZipCode = ""
    var pickUpTime = ""
    var notes = ""
    var postedTime = ""
    var capacity = ""
    var startingCapacity = ""
    var riders:[User]?
    var postId = ""
    
    init(rider:User, fromStreetAddress:String, fromCity:String, fromState:String, fromZipCode:String, toStreetAddress:String, toCity:String, toState:String, toZipCode:String, pickUpTime: String, notes:String, postedTime: String, capacity: String, startingCapacity:String, postId:String)
    {
        self.driver = rider
        self.firstName = rider.firstName
        self.lastName = rider.lastName
        self.phoneNumber = rider.phoneNumber
        self.email = rider.email
        self.fromStreetAddress = fromStreetAddress
        self.fromCity = fromCity
        self.fromState = fromState
        self.fromZipCode = fromZipCode
        self.toStreetAddress = toStreetAddress
        self.toCity = toCity
        self.toState = toState
        self.toZipCode = toZipCode
        self.postedTime = postedTime
        self.pickUpTime = pickUpTime
        self.capacity = capacity
        self.startingCapacity = startingCapacity
        self.notes = notes
        self.postId = postId
        
    }
    
    func addRider(_ rider: User){
        self.riders?.append(rider)
    }

    
    
    
    
    
    
}
