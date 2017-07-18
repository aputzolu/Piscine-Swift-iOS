//
//  42ApiTokenController.swift
//  rush00
//
//  Created by Edouard COUDERC on 6/17/17.
//  Copyright © 2017 Edouard COUDERC. All rights reserved.
//

import Foundation
import UIKit

class ApiTokenController {
    
    static var _token_expires_in : Date?
    static var _token : String?
    static var _token_updating : Bool = false
    static var _user_token_expires_in : Date?
    static var _user_token : String?
    static var _user_token_updating : Bool = false
    static var _user_id : Int?
    static var _user_name : String?
    static let MY_AWESOME_UID = "d0027f344600414cbf87b5d6dd4e1a63aea547cb2b75431b6c13eab71726a03c"
    static let MY_AWESOME_SECRET = "3178163229444a240c1057b0c4b3ec1f4206d82d1e091374926276152235d0d5"
    static let UNGUESSABLE_STRING = "wue82390joiewcnso9832ryudhiocj480r4ffwjiodjc0942r24wdwoicjsio"
    static let REDIRECT_URI = ("rush00://rush00".addingPercentEncoding(withAllowedCharacters: .urlUserAllowed))!
    
    static var token : String {
        get {
            return userToken
//            if _token_updating == false && (_token == nil || _token_expires_in! < Date()) {
//                updateToken()
//            }
//            while _token_updating {}
//            return _token ?? "undefined"
        }
    }
    
    static var userToken : String {
        get {
            if _user_token_updating == false && (_user_token == nil || _user_token_expires_in! < Date()) {
                authenticateUser()
            }
            while _user_token_updating {}
            return _user_token!
        }
    }
    
    static var userId : Int {
        get {
//            while _user_token_updating {}
            return _user_id!
        }
    }
    
    static var userName : String {
        get {
//            while _user_token_updating {}
            return _user_name!
        }
    }
    
    static func taskRequestToken(request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
//            print(response ?? "undefined response")
            if let err1 = error {
                print(err1)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        self._token = dic.object(forKey: "access_token") as! String?
                        let delay = dic.object(forKey: "expires_in") as! Int
                        self._token_expires_in = Date(timeInterval: TimeInterval(delay), since: Date())
                    }
                } catch (let err2) {
                    print(err2)
                }
            }
            self._token_updating = false
        }
        task.resume()
    }
    
    static func updateToken() {
        self._token_updating = true
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=client_credentials&client_id=\(MY_AWESOME_UID)&client_secret=\(MY_AWESOME_SECRET)".data(using: String.Encoding.utf8)
        taskRequestToken(request: request as URLRequest)
    }
    
    static func authenticateUser() {
        let scope = ("public forum".addingPercentEncoding(withAllowedCharacters: .urlUserAllowed))!
        let urlString = "https://api.intra.42.fr/oauth/authorize?client_id=\(MY_AWESOME_UID)&redirect_uri=\(REDIRECT_URI)&response_type=code&scope=\(scope)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("url error")
        }
    }
    
    static func taskRequestUser(request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
//            print(response ?? "undefined response")
            if let err1 = error {
                print(err1)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        self._user_id = dic.object(forKey: "id") as! Int?
                        self._user_name = dic.object(forKey: "login") as! String?
                    }
                } catch (let err2) {
                    print(err2)
                }
            }
            self._user_token_updating = false
        }
        task.resume()
    }
    
    static func connectedUser() {
        let url = URL(string: "https://api.intra.42.fr/v2/me")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(self._user_token!)", forHTTPHeaderField: "Authorization")
        taskRequestUser(request: request as URLRequest)
    }
    
    static func taskRequestUserToken(request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
//            print(response ?? "undefined response")
            if let err1 = error {
                print(err1)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        self._user_token = dic.object(forKey: "access_token") as! String?
                        let delay = dic.object(forKey: "expires_in") as! Int
                        self._user_token_expires_in = Date(timeInterval: TimeInterval(delay), since: Date())
                        self.connectedUser()
                    }
                } catch (let err2) {
                    print(err2)
                }
            }
        }
        task.resume()
    }
    
    static func updateUserToken(code : String) {
        self._user_token_updating = true
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=authorization_code&client_id=\(MY_AWESOME_UID)&client_secret=\(MY_AWESOME_SECRET)&code=\(code)&redirect_uri=\(REDIRECT_URI)".data(using: String.Encoding.utf8)
        taskRequestUserToken(request: request as URLRequest)
    }
    
}
