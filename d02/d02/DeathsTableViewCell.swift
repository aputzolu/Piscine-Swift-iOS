//
//  DeathsTableViewCell.swift
//  d02
//
//  Created by Anthony PUTZOLU on 6/14/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit

class DeathsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var deathLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var deaths: (String, String, String)? {
        didSet {
            if let d = deaths {
                nameLabel?.text = d.0
                deathLabel?.text = d.1
                dateLabel?.text = d.2
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
