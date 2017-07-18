//
//  SecondViewController.swift
//  d05
//
//  Created by Anthony PUTZOLU on 6/20/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit
import CoreLocation

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! PlaceTableViewCell
        cell.placeLabel.text = Data.places[indexPath.row].0
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "goToMap", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMap" {
            if let vc = segue.destination as? FirstViewController {
                vc.centerMapOnLocation(location: CLLocation(latitude: Data.places[index].2.latitude, longitude: Data.places[index].2.longitude))
            }
        }
    }
    
}
