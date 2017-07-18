//
//  Data.swift
//  d05
//
//  Created by Anthony PUTZOLU on 6/20/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import Foundation
import CoreLocation

//static var deaths: [(String, String, String)] 
struct Data {
    
    static var places: [(String, String, CLLocationCoordinate2D)] = [
        ("42", "Ecole super stylée", CLLocationCoordinate2D(latitude: 48.896602, longitude: 2.318612)),
        ("Home", "My bed", CLLocationCoordinate2D(latitude: 48.887373, longitude: 2.310516)),
        ("Palais de Tokyo", "Whoa", CLLocationCoordinate2D(latitude: 48.865223, longitude: 2.296575)),
        ("Moulin Rouge", "Whoa", CLLocationCoordinate2D(latitude: 48.884036, longitude: 2.331550)),
    ]
}
