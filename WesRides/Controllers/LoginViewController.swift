//
//  LoginViewController.swift
//  WesRides
//
//  Created by Dan on 7/10/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
        GIDSignIn.sharedInstance().delegate = self
    }
}


extension LoginViewController : GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // Error
        if let error = error {
            print ("Failed to log in Google: ", error)
            return
        }
        
        print("Successfully logged into Google", user)
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // Error
                print("Failed to create a Firebase user with Google account:", error)
                return
            }
            // User is signed in
            guard let user = user
                else { return }
            
            
            let userRef = Database.database().reference().child("users").child(user.uid)
            
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let user = User(snapshot: snapshot){
                    print ("User already exists \(user.username).")
                }
                else{
                    
                    let userEmail = user.email!
                    let userFullName = user.displayName
                    let username =  userEmail.components(separatedBy: "@")[0]
                    let riderAttrs = ["username": username, "userEmail": userEmail, "fullName": userFullName]
                    userRef.setValue(riderAttrs)
                }
            })
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}
