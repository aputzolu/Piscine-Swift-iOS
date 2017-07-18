//
//  CollectionViewCell.swift
//  d03
//
//  Created by Anthony PUTZOLU on 6/15/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    var imageCell : UIImage?
        {
        didSet{
            self.imageViewCell?.image = self.imageCell
        }
    }
    
    @IBOutlet var imageViewCell: UIImageView!
}
