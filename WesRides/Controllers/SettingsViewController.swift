//
//  SettingsViewController.swift
//  WesRides
//
//  Created by Dan on 8/6/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }

    func cancelTapped(){
        dismiss(animated: true, completion: nil)
    }


}
