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
    
    static func create(_ firUser: FIRUser, username: String, userEmail: String, completion: @escaping (User?) -> Void) {
        let riderAttrs = ["username": username, "userEmail": userEmail]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        ref.setValue(riderAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
}
