//
//  ChatViewController.swift
//  d07
//
//  Created by Anthony PUTZOLU on 6/22/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import RecastAI
import ForecastIO

class ChatViewController: JSQMessagesViewController {

    struct User {
        let id: String
        let name: String
    }

    var request: String!
    let user1 = User(id: "1", name: "Steve")
    var bot : RecastAIClient?
    var locationsTab : [Double] = []
    let client = DarkSkyClient(apiKey: "f8b61a8da57d1999785d6c3a5694c71e")
    
    var currentUser: User {
        return user1
    }

    var messages = [JSQMessage]()
    
    func getMessages() -> [JSQMessage] {
        var messages = [JSQMessage]()
        
        let message1 = JSQMessage(senderId: "2", displayName: "Steve", text: "Hello ❤️")
        
        messages.append(message1!)
        return messages
    }

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        request = text
        messages.append(message!)
        makeRequest()
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        return bubbleFactory?.incomingMessagesBubbleImage(with: .blue)
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = currentUser.id
        self.senderDisplayName = currentUser.name
        self.messages = getMessages()
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
                    if let weather = currentForecast.currently?.summary {
                        if let place = self.request {
                            let message = JSQMessage(senderId: "2", displayName: "Tim", text: "The weather is \(weather) in \(place) 😍")
                            self.messages.append(message!)
                            self.collectionView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let message = JSQMessage(senderId: "2", displayName: "Tim", text: String(describing: error))
                    self.messages.append(message!)
                    self.collectionView.reloadData()
                }
            }
        }
        locationsTab.removeAll()
    }
    
    func makeRequest()
    {
        DispatchQueue.main.async {
            let message = JSQMessage(senderId: "2", displayName: "Tim", text: "Please wait a minute, i'm looking for your request 🤔")
            self.messages.append(message!)
            self.collectionView.reloadData()
            
        }
        self.bot?.textRequest(request.uppercased(), successHandler: { (response) in
            self.recastRequestDone(response)
        }, failureHandle: { (error) in
            DispatchQueue.main.async {
                let message = JSQMessage(senderId: "2", displayName: "Tim", text: "Recast doesn't respond 🙄")
                self.messages.append(message!)
                self.collectionView.reloadData()
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
                getForecast()
            }
        } else {
            DispatchQueue.main.async {
                let message = JSQMessage(senderId: "2", displayName: "Tim", text: "I don't understand 😴")
                self.messages.append(message!)
                self.collectionView.reloadData()

            }
        }
    }
 
    
    
}
