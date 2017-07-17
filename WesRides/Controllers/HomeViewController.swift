//
//  ViewController.swift
//  WesRides
//
//  Created by Dan on 7/7/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class HomeViewController: UIViewController {
    
    @IBOutlet weak var openMenu: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sideMenu()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sideMenu() {
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    @IBAction func newRideTapped(_ sender: Any) {
        performSegue(withIdentifier: "newRideSegue", sender: self)
        
    }
    
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
    }
    

}

extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell") as! PostHeaderCell
            cell.usernameLabel.text = User.current.username
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageCell") as! PostImageCell
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell") as! PostActionCell
            
            return cell
            
        default:
            fatalError("Error: unexpected indexPath.")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    


}
