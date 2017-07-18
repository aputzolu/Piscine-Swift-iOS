//
//  ViewController.swift
//  d07
//
//  Created by Anthony PUTZOLU on 6/22/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit
import RecastAI
import ForecastIO

class ViewController: UIViewController {

    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var requestLabel: UITextField!
    
    @IBAction func goToChat(_ sender: Any) {
        performSegue(withIdentifier: "goToChat", sender: nil)
    }
    
    @IBAction func requestButton(_ sender: Any) {
        if requestLabel.text != "" {
            makeRequest()
            responseLabel.text = "Ask to recast"
        }
    }
    
    var bot : RecastAIClient?
    var locationsTab : [Double] = []
    let client = DarkSkyClient(apiKey: "f8b61a8da57d1999785d6c3a5694c71e")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        client.units? = .auto
        client.language? = .french
        self.bot = RecastAIClient(token : "0fa98edad22a4249c69cc110c88734a8")
        self.bot = RecastAIClient(token : "0fa98edad22a4249c69cc110c88734a8", language: "fr")
    }
    
    func getForecast() {
        self.client.getForecast(latitude: self.locationsTab[1], longitude: self.locationsTab[0]) { result in
            switch result {
            case .success(let currentForecast, let requestMetadata):
                print(requestMetadata.responseTime ?? "")
                DispatchQueue.main.async {
                    self.responseLabel.text = currentForecast.currently?.summary
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.responseLabel.text = "Can't get weather because \(error.localizedDescription)"
                }
            }
        }
        locationsTab.removeAll()
    }
    
    func makeRequest()
    {
        self.bot?.textRequest(requestLabel.text!.uppercased(), successHandler: { (response) in
            self.recastRequestDone(response)
        }, failureHandle: { (error) in
            DispatchQueue.main.async {
                self.responseLabel.text = "Recast doesn't respond"
            }
        })
    }
    
    func recastRequestDone(_ response : Response)
    {
        let location = response.get(entity: "location")
        if let lng = location?["lng"] {
            if let lat = location?["lat"] {
                print(lng)
                print(lat)
                locationsTab = [lng as! Double, lat as! Double]
                print(locationsTab)
                DispatchQueue.main.async {
                    self.responseLabel.text = "Getting Weather"
                }
                getForecast()
            }
        } else {
            DispatchQueue.main.async {
                self.responseLabel.text = "Location no found"
            }
        }
    }
}
