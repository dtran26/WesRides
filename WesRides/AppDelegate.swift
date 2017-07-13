//
//  AppDelegate.swift
//  WesRides
//
//  Created by Dan on 7/7/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        //Set initial screen to LoginViewController
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        
        //User persistence
        Auth.auth().addStateDidChangeListener() { auth, user in
            if let user = user {
                print(user.uid)
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let viewController = storyboard.instantiateViewController(withIdentifier: "Main")
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
            }
        }
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
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
                    print("321")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "signIn"), object: self)
                }
                else{
                    
                    let userEmail = user.email!
                    let username =  userEmail.components(separatedBy: "@")[0]
                    let riderAttrs = ["username": username, "userEmail": userEmail]
                    userRef.setValue(riderAttrs)
                    print(userEmail)
                    print(username)
                    print(user.uid)
                    print ("New user!")
                    print("123")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "signIn"), object: self)
                    
                    
                }
            })
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    
    
}


