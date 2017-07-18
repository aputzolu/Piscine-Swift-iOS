//
//  Protocol.swift
//  d04
//
//  Created by Anthony PUTZOLU on 6/16/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import Foundation

protocol APITwitterDelegate: class {
    
    func getTweet(tweet: [Tweet])
    func getError(error: NSError)
}
