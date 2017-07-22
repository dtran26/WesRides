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
    var email = ""
    var from = ""
    var destination = ""
    var pickUpTime = Date()
    var notes = ""
    var capacity = ""
    let creationDate: Date
    let creatorUID : String
    let creatorDisplayName : String
    let offerNewRideBool: Bool
    
    init(from:String, destination:String, pickUpTime: Date, notes:String, capacity: String, creatorUID: String, creatorDisplayName: String, offerNewRideBool: Bool )
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
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
            let from = dict["startLocation"] as? String,
            let destination = dict["endLocation"] as? String,
            let pickUpTime = dict["pickUptime"] as? TimeInterval,
            let creationDate = dict["createdAt"] as? TimeInterval,
            let creatorUID = dict["creatorUID"] as? String,
            let creatorDisplayName = dict["creatorDisplayName"] as? String,
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
                "offerNewRideBool" : offerNewRideBool,
                "notes" : notes]
    }
    
}
