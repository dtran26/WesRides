//
//  Message.Swift
//  WesRides
//
//  Created by Dan on 8/2/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot


class Message {
    
    var key: String?
    let content: String
    let timestamp: Date
    let sender: User
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String : Any],
            let content = dict["content"] as? String,
            let timestamp = dict["timestamp"] as? TimeInterval,
            let userDict = dict["sender"] as? [String : Any],
            let uid = userDict["uid"] as? String,
            let fullName = userDict["fullName"] as? String,
            let userEmail = userDict["userEmail"] as? String
            else { return nil }
        
        self.key = snapshot.key
        self.content = content
        self.timestamp = Date(timeIntervalSince1970: timestamp)
        self.sender = User(uid: uid, userRmail: userEmail, fullName: fullName)
    }
    

}
