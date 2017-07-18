//
//  ViewController.swift
//  D00
//
//  Created by ANTHONY on 12/06/2017.
//  Copyright © 2017 AppFish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var a: Double = 0
    var b: Double = 0
    var str: String? = ""
    var str2: String? = ""
    var operation: String = ""
    var flag: Int = 0
    var equal: Int = 0
    
    @IBOutlet var result: UILabel!
    
    @IBAction func operationsButtons(_ sender: UIButton) {
        switch sender.currentTitle! {
        case "NEG":
            a = -a
            result.text = String(a)
        case "AC":
            str = "0"
            str2 = ""
            a = 0
            b = 0
            flag = 0
            result.text = str
        default:
            operation = sender.currentTitle!
            flag = 1
        }
        if (b != 0) {
            operation(operation: operation)
            str2 = ""
        }
        equal = 0
        print("Action : \(sender.currentTitle)")
    }
    
    @IBAction func calculate(_ sender: Any) {
        operation(operation: operation)
        flag = 0
        b = 0
        str2 = ""
        equal = 1
    }
    
    func divid() {
        if (b == 0) {
            result.text = "Divided by 0 error"
        } else {
            a = a / b
        }

    }
    
    func operation(operation: String) {
        switch operation {
        case "+":
            a = a + b
        case "-":
            a = a - b
        case "*":
            a = a * b
        case "/":
            divid()
        default:
            print("error")
        }
        equal = 0
        if (operation == "/" && b == 0) {
            result.text = "Not a number"
        } else {
            result.text = String(a)
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        print("Action : \(sender.currentTitle)")
        if (equal == 1) {
            equal = 0
            flag = 0
            str = ""
            str2 = ""
        }
        if (flag == 0) {
            str = str! + sender.currentTitle!
            a = Double(str!)!
            result.text = String(a)
        } else {
            str2 = str2! + sender.currentTitle!
            b = Double(str2!)!
            result.text = String(b)
        }
    }

    @IBOutlet var label: UILabel!
    
    @IBAction func clickMe(_ sender: Any) {
        print("Hello World !")
        result.text = "Hello World !"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
