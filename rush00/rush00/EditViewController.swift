//
//  EditViewController.swift
//  rush00
//
//  Created by Edouard COUDERC on 6/18/17.
//  Copyright © 2017 Edouard COUDERC. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    
    var type : Type?
    var current : Data?
    var action : Action?
    var index : Int?
    var apiController : APIController?
    var topicId : NSNumber?
    var messageId : NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        contentTextView.layer.cornerRadius = 5
//        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
//        contentTextView.layer.borderWidth = 1
        if let d = current {
            contentTextView.text = d.name
        }
        contentTextView.becomeFirstResponder()
    }
    
//    func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.contentTextViewBottomContraint.constant += keyboardSize.height
//        }
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            self.contentTextViewBottomContraint.constant -= keyboardSize.height
//        }
//    }
    
    @IBAction func doneButton() {
        performSegue(withIdentifier: "doneSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            if let vc = segue.destination as? ViewController {
                let content = contentTextView.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if content != "" {
                    switch action! {
                    case Action.Add:
                        switch type! {
                        case Type.Topic:
                            apiController?.postTopic(content: "new content", name: content, kind: "normal")
                        case Type.Message:
                            apiController?.postMessage(topicId: topicId!, content: content)
                        case Type.Answer:
                            apiController?.postAnswer(topicId: topicId!, messagesId: messageId!, content: content)
                        }
                    case Action.Edit:
                        current?.name = content
                        switch type! {
                        case Type.Topic:
                            apiController?.editTopic(id: current!.id, name: content, kind: "normal")
                        default:
                            apiController?.editMessage(id: current!.id, content: content)
                        }
                        vc.editData(data : current!, index : index!)
                    }
                }
            }
        }
    }
    
}
