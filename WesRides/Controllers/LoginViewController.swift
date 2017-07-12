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
typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // IF THE USER IS ALREADY SIGNED IN SWITCH TO MAIN LAB ROOM
        
//        Auth.auth().addStateDidChangeListener() { auth, user in
//            if user != nil {
//                self.switchStoryboard()
//            }
//        }
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //NotificationCenter.default.addObserver(self, selector: #selector(segueToMain), name: NSNotification.Name(rawValue: "signIn"), object: nil)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "signIn"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func segueToMain() {
        self.performSegue(withIdentifier: "login", sender: nil)
    }

}
