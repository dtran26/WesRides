//
//  Ride.swift
//  WesRides
//
//  Created by Dan on 7/13/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Ride {
    
    var key : String?
    var from = ""
    var destination = ""
    var pickUpTime = Date()
    var notes = ""
    let capacity : Int
    let creationDate: Date
    let creatorUID : String
    let creatorDisplayName : String
    let creatorEmail : String
    let offerNewRideBool: Bool
    
    init(from:String, destination:String, pickUpTime: Date, notes:String, capacity: Int, creatorUID: String, creatorDisplayName: String, offerNewRideBool: Bool, creatorEmail: String )
    {
        self.from = from
        self.destination = destination
        self.pickUpTime = pickUpTime
        self.capacity = capacity
        self.notes = notes
        self.creationDate = Date()
        self.creatorUID = creatorUID
        self.creatorDisplayName = creatorDisplayName
        self.offerNewRideBool = offerNewRideBool
        self.creatorEmail = creatorEmail
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let from = dict["startLocation"] as? String,
            let destination = dict["endLocation"] as? String,
            let pickUpTime = dict["pickUptime"] as? TimeInterval,
            let creationDate = dict["createdAt"] as? TimeInterval,
            let capacity = dict["capacity"] as? Int,
            let creatorUID = dict["creatorUID"] as? String,
            let creatorDisplayName = dict["creatorDisplayName"] as? String,
            let creatorEmail = dict["creatorEmail"] as? String,
            let offerNewRideBool = dict["offerNewRideBool"] as? Bool
            else { return nil }
        
        self.key = snapshot.key
        self.from = from
        self.destination = destination
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        self.pickUpTime = Date(timeIntervalSince1970: pickUpTime)
        self.creatorUID = creatorUID
        self.creatorDisplayName = creatorDisplayName
        self.offerNewRideBool = offerNewRideBool
        self.capacity = capacity
        self.creatorEmail = creatorEmail
    }

    var dictValue: [String : Any] {
        let createdAgo = creationDate.timeIntervalSince1970
        let time = pickUpTime.timeIntervalSince1970
        
        return ["startLocation" : from,
                "endLocation" : destination,
                "createdAt" : createdAgo,
                "pickUptime" : time,
                "capacity" : capacity,
                "creatorUID" : creatorUID,
                "creatorDisplayName" : creatorDisplayName,
                "creatorEmail" : creatorEmail,
                "offerNewRideBool" : offerNewRideBool,
                "notes" : notes]
    }
    
}
