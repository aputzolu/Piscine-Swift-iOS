//
//  API42Delegate.swift
//  rush00
//
//  Created by Anthony PUTZOLU on 6/17/17.
//  Copyright © 2017 Edouard COUDERC. All rights reserved.
//

import Foundation

protocol API42Delegate: class {
//    func addMessage(message: Message)
//    func editMessage(message: Message)
//    func deleteMessage(message: Message)
    func addData(data: Data)
    func editData(data : Data, index : Int)
    func addNewData(data : Data)
    func isScrollable()
//    func editTopic(topic: Topic)
//    func deleteTopic(topic: Topic)
}
