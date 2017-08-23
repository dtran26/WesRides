//
//  ScheduleSelectionViewController.swift
//  WesRides
//
//  Created by Dan on 8/23/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit


class ScheduleSelectionViewController: UIViewController {

    var myClasses = [Class]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ScheduleSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myClassCell = tableView.dequeueReusableCell(withIdentifier: "ClassCell", for: indexPath)
        
        return myClassCell
    }
}
