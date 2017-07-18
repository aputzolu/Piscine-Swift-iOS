//
//  ImageViewController.swift
//  d03
//
//  Created by Anthony PUTZOLU on 6/15/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    
    var imageView: UIImageView?
    var image: UIImage? {
        didSet {
            imageView = UIImageView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView!)

        let widthScale = view.bounds.size.width / (imageView?.bounds.width)!
        let heightScale = view.bounds.size.height / (imageView?.bounds.height)!
        let minScale = min(widthScale, heightScale)
        
        scrollView.maximumZoomScale = 100

        scrollView.minimumZoomScale = minScale
        view.layoutIfNeeded()
        //scrollView.zoomScale = minScale
    }

    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
