//
//  ViewController.swift
//  d04
//
//  Created by Anthony PUTZOLU on 6/16/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, APITwitterDelegate {
    
    var token: String?
    var tweets = [Tweet]()
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            getToken()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func makeRequest(content: String) {
        if let token = self.token {
            let apiController = APIController(delegate: self, token: token)
            apiController.getRequest(string: content)
        }
    }
    
    func getToken() {
        let CUSTOMER_KEY = "6YCfalwHVWBYO35e7oc2OWvH4"
        let CUSTOMER_SECRET = "Fm2AB84BdjNTVsfFxIDO42MzdmfxSxqrNIumaqDuAVZac2UJll"
        let BEARER = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        let url = URL(string: "https://api.twitter.com/oauth2/token")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response ?? "")
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                do {
                    if let dic: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            print(dic["access_token"] ?? "")
                            self.token = dic["access_token"] as? String
                    }
                } catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func getTweet(tweet: [Tweet]) {
        tweets = tweet
        tableView.reloadData()
    }
    
    func getError(error: NSError) {
        let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetTableViewCell
        cell.nameLabel.text = tweets[indexPath.row].name
        cell.dateLabel.text = tweets[indexPath.row].date
        cell.tweetLabel.text = tweets[indexPath.row].text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            makeRequest(content: textField.text!)
        }
        self.view.endEditing(true)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

