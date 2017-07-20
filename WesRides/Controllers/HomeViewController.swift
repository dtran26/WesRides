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


class HomeViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openMenu: UIBarButtonItem!

    var rides = [Ride]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sideMenu()
        
        configureTableView()
        
        UserService.posts(completion: { (posts) in
            self.rides = posts
            self.tableView.reloadData()
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTimeline), name: NSNotification.Name(rawValue: "upload"), object: nil)
    }

    func sideMenu() {
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func reloadTimeline() {
        UserService.posts(completion: { (posts) in
            self.rides = posts
            self.tableView.reloadData()
        })
    }
    


    @IBAction func newRideTapped(_ sender: Any) {
        performSegue(withIdentifier: "newRideSegue", sender: self)
        
    }
    
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
    }
    

    func configureTableView() {
        // remove separators for empty cells
        tableView.tableFooterView = UIView()
        // remove separators from cells
        tableView.separatorStyle = .none
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = rides[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideCell", for: indexPath) as! RideCell
        
        cell.destinationLabel.text = post.destination
        cell.fromLabel.text = post.from
        cell.timeLabel.text = post.pickUpTime.string(dateStyle: .long, timeStyle: .short)
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    
    
    
    
    
}
