//
//  DataTableViewCell.swift
//  rush00
//
//  Created by Edouard COUDERC on 6/17/17.
//  Copyright © 2017 Edouard COUDERC. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var auteurLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var data : Data? {
        didSet {
            if let d = data {
                auteurLabel?.text = d.auteur
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm"
                dateLabel?.text = dateFormatter.string(from: d.date)
                nameLabel?.text = d.name
                if d.auteur == ApiTokenController.userName {
                    auteurLabel?.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                }
            }
        }
    }

}
