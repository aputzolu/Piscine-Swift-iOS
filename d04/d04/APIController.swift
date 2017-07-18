//
//  APIController.swift
//  d04
//
//  Created by Anthony PUTZOLU on 6/16/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import Foundation

class APIController {
    
    weak var delegate : APITwitterDelegate?
    let token: String
    
    init(delegate: APITwitterDelegate, token: String) {
        self.delegate = delegate
        self.token = token
    }

    func getRequest(string: String) {
        let q = string.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) //stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(q!)&count=100&lang=fr&result_type=recent")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response ?? "")
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                do {
                    if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        var tweets: [Tweet] = []
                        if let tweetsD: [NSDictionary] = resp["statuses"] as? [NSDictionary] {
                            for tweet in tweetsD {
                                let user = tweet["user"] as! NSDictionary
                                if let name = user["name"] as? String {
                                    if let text = tweet["text"] as? String {
                                        if let date = tweet["created_at"] as? String {
                                            tweets.append(Tweet(name: name, text: text, date: date))
                                        }
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                self.delegate?.getTweet(tweet: tweets)
                            }
                        }
                    }
                } catch (let error) {
                    DispatchQueue.main.async {
                        self.delegate?.getError(error: error as NSError)
                    }
                }
            }
        }
        task.resume()
    }
}
