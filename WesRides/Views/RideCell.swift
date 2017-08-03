//
//  RideCell.swift
//  WesRides
//
//  Created by Dan on 7/18/17.
//  Copyright © 2017 dtran. All rights reserved.
//

import UIKit

class RideCell: UITableViewCell{

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
