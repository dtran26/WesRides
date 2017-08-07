//
//  MenuViewController.swift
//  WesRides
//
//  Created by Dan on 7/12/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class MenuViewController: UITableViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    
    let currentUser = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        
//        self.view.backgroundColor = UIColor.init(gradientStyle: .topToBottom, withFrame: view.frame, andColors: colors)

        tableView.tableFooterView = UIView()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.isUserInteractionEnabled = true
    }
    
    
    @IBAction func logout(_ sender: UITapGestureRecognizer) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        performSegue(withIdentifier: "logOut", sender: self)
        
    }
    
}
