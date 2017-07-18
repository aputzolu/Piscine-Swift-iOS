//
//  AddDeathViewController.swift
//  d02
//
//  Created by Anthony PUTZOLU on 6/14/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

class AddDeathViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var deathTextView: UITextView!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func addData(_ sender: Any) {
        print(nameTextField.text ?? "")
        print(deathTextView.text ?? "")
        print(datePicker.description)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFirstView" {
            if let vc = segue.destination as? ViewController {
                if (nameTextField.text != "") {
                    Data.deaths.append((nameTextField.text!, deathTextView.text!, datePicker.date.toString(dateFormat: "EEEE, MMM dd, yyyy, HH:mm")))
                    vc.tableView.reloadData()
                }
            }
        }
    }

    @IBAction func goBack(_ sender: Any) {
        performSegue(withIdentifier: "goToFirstView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a Person"
        datePicker.minimumDate = NSCalendar.current.date(byAdding: NSDateComponents() as DateComponents, to: NSDate() as Date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
