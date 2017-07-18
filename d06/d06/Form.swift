//
//  Form.swift
//  d06
//
//  Created by Anthony PUTZOLU on 6/21/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit

class Shape: UIView {
    
    let colors: [UIColor] = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.purple]
    var paths: [UIBezierPath] = []
    let random =  Int(arc4random_uniform(UInt32(2)))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        if random == 0 {
            return .ellipse
        }
        return .rectangle
    }
    
    override func draw(_ rect: CGRect) {
        let pathCircle = UIBezierPath(ovalIn: rect)
        let pathSquare = UIBezierPath(rect: rect)
        paths = [pathCircle, pathSquare]
        colors[Int(arc4random_uniform(UInt32(4)))].setFill()
        paths[random].fill()
        if random == 0 {
            self.layer.cornerRadius = self.frame.size.width / 2
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
}
