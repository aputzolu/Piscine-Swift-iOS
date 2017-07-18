//
//  ConnectViewController.swift
//  rush00
//
//  Created by Edouard COUDERC on 6/17/17.
//  Copyright © 2017 Edouard COUDERC. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ApiTokenController._user_token_expires_in = nil
        ApiTokenController._user_token = nil
        ApiTokenController._user_id = nil
        ApiTokenController._user_name = nil
    }

    @IBAction func authenticateUser(sender : UIButton) {
        ApiTokenController.authenticateUser()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "authenticateSegue" {
            if let nav = segue.destination as? UINavigationController {
                if let dest = nav.topViewController as? ViewController {
                    dest.type = Type.Topic
                }
            }
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        //        print(segue.identifier ?? "undefined")
    }

}
