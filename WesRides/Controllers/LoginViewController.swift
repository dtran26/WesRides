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

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
                    print(userEmail)
                    print(username)
                    print(user.uid)
                    print(userFullName!)
                    print(user.photoURL!)
                    print ("New user!")       
                }
            })
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }


    
    @IBAction func unwindToLoginVC(segue: UIStoryboardSegue) {
        GIDSignIn.sharedInstance().delegate = self
    }
}
