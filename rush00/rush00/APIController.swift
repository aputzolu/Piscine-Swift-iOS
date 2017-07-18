//
//  APIController.swift
//  rush00
//
//  Created by Anthony PUTZOLU on 6/17/17.
//  Copyright © 2017 Edouard COUDERC. All rights reserved.
//

import Foundation

class APIController {
    
    static var PER_PAGE : Int = 30
    
    weak var delegate: API42Delegate?
    let token: String?
    
    init(delegate: API42Delegate, token: String) {
        self.delegate = delegate
        self.token = token
    }
    
    func getData(query: String, content : String, page : Int) {
        let url = URL(string: "https://api.intra.42.fr/v2/\(query)per_page=\(APIController.PER_PAGE)&page=\(page)")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                //                var topics: [Data] = []
                do {
                    //                    print(d)
                    if let resp: NSArray = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray {
                        for dic in resp {
                            if let topic = dic as? NSDictionary {
                                if let author = topic["author"] as? NSDictionary {
                                    if let authorName = author["login"] as? String {
                                        if let name = topic[content] as? String {
                                            if let dateString = topic["created_at"] as? String {
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                                let date = dateFormatter.date(from: dateString)
                                                if let id = topic["id"] as? NSNumber {
                                                    //                                                    topics.append(Data(id: id, name: name, auteur: authorName, date: date!))
                                                    DispatchQueue.main.async {
//                                                        print(date!)
                                                        self.delegate?.addData(data: Data(id: id, name: name, auteur: authorName, date: date!))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } catch (let error) {
                    print(error)
                }
                DispatchQueue.main.async {
                    self.delegate?.isScrollable()
                }
                //                if topics.count > 0 {
                //                    self.getTopics(page: page + 1)
                //                }
            }
        }
        task.resume()
    }
    func postTopic(content: String, name: String, kind: String) {
        let params: [String: Any] = [
            "topic" : [
                "name": name,
                "kind": kind,
                "author_id": ApiTokenController.userId,
                "messages_attributes": [
                    [
                        "content": content,
                        "author_id": ApiTokenController.userId
                    ]
                ],
                "cursus_ids": ["1"],
                "tag_ids": ["574"],
            ]
        ]
        let json = try! JSONSerialization.data(withJSONObject: params)
        let url = URL(string: "https:api.intra.42.fr/v2/topics")
        var request = URLRequest(url: url! as URL)
        request.setValue("Bearer \(ApiTokenController.userToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = json
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                do {
                    print(d)
                    if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let id = resp["id"] {
                            let data = Data(id: id as! NSNumber, name: name, auteur: ApiTokenController.userName, date: Date())
                            DispatchQueue.main.async {
                                self.delegate?.addNewData(data: data)
                            }
                        }
                    }
                } catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func postAnswer(topicId: NSNumber, messagesId: NSNumber, content: String) {
        let params: [String: Any] = [
            "message" : [
                "author_id": ApiTokenController.userId,
                "content": content
            ]
        ]
        let json = try! JSONSerialization.data(withJSONObject: params)
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(String(describing: topicId))/messages/\(String(describing: messagesId))/messages")
        var request = URLRequest(url: url! as URL)
        request.httpBody = json
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(ApiTokenController.userToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response ?? "")
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                do {
                    print(d)
                    if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        if let id = resp["id"] {
                            let data = Data(id: id as! NSNumber, name: content, auteur: ApiTokenController.userName, date: Date())
                            DispatchQueue.main.async {
                                self.delegate?.addNewData(data: data)
                            }
                        }
                        
                    }
                } catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func postMessage(topicId: NSNumber, content: String) {
        let params: [String: Any] = [
            "message" : [
                "author_id": ApiTokenController.userId,
                "content": content
            ]
        ]
        let json = try! JSONSerialization.data(withJSONObject: params)
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(String(describing: topicId))/messages")
        var request = URLRequest(url: url! as URL)
        request.httpBody = json
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(ApiTokenController.userToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response ?? "")
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                do {
                    print(d)
                    if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(resp)
                        if let id = resp["id"] {
                            let data = Data(id: id as! NSNumber, name: content, auteur: ApiTokenController.userName, date: Date())
                            DispatchQueue.main.async {
                                self.delegate?.addNewData(data: data)
                            }
                        }
                    }
                } catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func deleteMessage(id: NSNumber) {
        let url = URL(string: "https://api.intra.42.fr/v2/messages/\(id)")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(ApiTokenController.userToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response ?? "")
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                do {
                    print(d)
                    if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(resp)
                        
                    }
                } catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func editMessage(id: NSNumber, content: String) {
        let params: [String: Any] = [
            "message" : [
                "content": content
            ]
        ]
        let json = try! JSONSerialization.data(withJSONObject: params)
        let url = URL(string: "https://api.intra.42.fr/v2/messages/\(String(describing: id))")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "PUT"
        request.httpBody = json
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(ApiTokenController.userToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response ?? "")
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                do {
                    print(d)
                    if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(resp)
                        
                    }
                } catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    
    func deleteTopic(id: NSNumber) {
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(String(describing: id))")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(ApiTokenController.userToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response ?? "")
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                do {
                    print(d)
                    if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(resp)
                        
                    }
                } catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func editTopic(id: NSNumber, name: String, kind: String) {
        let params: [String: Any] = [
            "topic" : [
                "name": name,
                "kind": kind,
                "author_id": ApiTokenController.userId,
                "cursus_ids": ["1"],
                "tag_ids": ["574"],
            ]
        ]
        let json = try! JSONSerialization.data(withJSONObject: params)
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(String(describing: id))")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "PUT"
        request.httpBody = json
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(ApiTokenController.userToken)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(response ?? "")
            if error != nil {
                print(error ?? "")
            } else if let d = data {
                do {
                    print(d)
                    if let resp: NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print(resp)
                        
                    }
                } catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
