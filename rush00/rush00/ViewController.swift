//
//  ViewController.swift
//  rush00
//
//  Created by Edouard COUDERC on 6/17/17.
//  Copyright © 2017 Edouard COUDERC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, API42Delegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var outButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var type : Type?
    var current : Data?
    var datas : [Data] = []
    var page : Int = 0
    var apiController : APIController?
    var topicId : NSNumber?
    var messageId : NSNumber?
    var scrolling : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController = APIController(delegate: self, token: ApiTokenController.token)
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        if let curr = current {
            self.title = curr.name
        } else {
            self.title = type!.rawValue
        }
        if type == Type.Topic {
            outButton.isEnabled = true
            outButton.title = "Sign out"
        } else {
            outButton.isEnabled = false
            outButton.title = ""
        }
        loadMore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell") as! DataTableViewCell
        cell.data = datas[indexPath.row]
        
//        if indexPath.row >= topics.count - 10 {
//            self.loadTopics()
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            switch self.type! {
            case Type.Topic:
                self.apiController?.deleteTopic(id: self.datas[index.row].id)
            default:
                self.apiController?.deleteMessage(id: self.datas[index.row].id)
            }
            self.datas.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: .fade)
        }
        delete.backgroundColor = .red
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("edit button tapped")
            self.performSegue(withIdentifier: "addSegue", sender: index.row)
        }
        edit.backgroundColor = .orange
        if self.type == Type.Message && indexPath.row == 0 {
            return [edit]
        }
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if ApiTokenController.userName == datas[indexPath.row].auteur {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = datas.count - 1
        if lastElement >= APIController.PER_PAGE-10 && indexPath.row == lastElement {
//            let qos = DispatchQoS.background.qosClass
//            let queue = DispatchQueue.global(qos : qos)
//            queue.async {
//                while self.scrolling {}
//                tableView.isScrollEnabled = false
//                DispatchQueue.main.async{
                    activityIndicatorView.startAnimating()
                    activityIndicatorView.isHidden = false
                    self.loadMore()
//                }
//            }
        }
    }
    
    func isScrollable() {
//        tableView.isScrollEnabled = true
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
    
    func addData(data : Data) {
        let qos = DispatchQoS.background.qosClass
        let queue = DispatchQueue.global(qos : qos)
        queue.async {
            while self.scrolling {}
//            self.tableView.isScrollEnabled = false
            DispatchQueue.main.async{
                self.datas.append(data)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.datas.count-1, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        }
    }
 
    func addNewData(data : Data) {
        if (type == Type.Topic) {
            datas.insert(data, at: 0)
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            tableView.endUpdates()
        } else {
            addData(data: data)
        }
    }
    
    func editData(data : Data, index : Int) {
        datas[index] = data
        tableView.beginUpdates()
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.top)
        tableView.endUpdates()
    }
    
    func loadMore() {
        page += 1
        var query = ""
        var content = "content"
        switch type! {
        case Type.Topic:
            query = "topics?"
            content = "name"
        case Type.Message:
            query = "topics/\(current!.id)/messages?"
        case Type.Answer:
            query = "messages/\(current!.id)/messages?"
        }
        apiController?.getData(query : query, content : content, page : page)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrolling = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.scrolling = true
    }
  
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "selfSegue" && type! == Type.Answer {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selfSegue" {
            let cell = sender as! DataTableViewCell
            let dest = segue.destination as! ViewController
            switch type! {
            case Type.Topic:
                dest.type = Type.Message
                dest.topicId = cell.data?.id
            case Type.Message:
                dest.type = Type.Answer
                dest.topicId = topicId
                dest.messageId = cell.data?.id
            case Type.Answer:
                dest.type = Type.Answer
                dest.topicId = topicId
                dest.messageId = cell.data?.id
            }
            dest.current = cell.data
        } else if segue.identifier == "addSegue" {
            let dest = segue.destination as! EditViewController
            dest.title = self.title
            dest.action = Action.Add
            dest.apiController = apiController
            dest.topicId = topicId
            dest.messageId = messageId
            dest.type = type
            if let index = sender as? Int {
                let d = self.datas[index]
                dest.action = Action.Edit
                dest.current = d
                dest.index = index
                dest.title = self.title
            }
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        //        print(segue.identifier ?? "undefined")
        if segue.identifier == "doneSegue" {
            
        }
    }
}
