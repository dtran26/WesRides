//
//  ScheduleSelectionViewController.swift
//  WesRides
//
//  Created by Dan on 8/23/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ScheduleSelectionViewController: UIViewController {

    var myClasses = [Class]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.flatWhite
    }
    
    @IBAction func addClass(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addClass", sender: sender)

    }
    
    
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


extension ScheduleSelectionViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let str = "No Classes"
        let attrs = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.flatWhite
    }

}
