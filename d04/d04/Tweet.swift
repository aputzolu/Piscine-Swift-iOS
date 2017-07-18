//
//  Tweet.swift
//  d04
//
//  Created by Anthony PUTZOLU on 6/16/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import Foundation

struct Tweet: CustomStringConvertible {
    let name: String
    let text: String
    let date: String
    
    var description: String {
        return ("\(name) has tweet \(text)")
    }
}
