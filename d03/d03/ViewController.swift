//
//  ViewController.swift
//  d03
//
//  Created by Anthony PUTZOLU on 6/15/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var image: UIImage?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath as IndexPath) as! CollectionViewCell
        let qos = DispatchQoS.background.qosClass
        let queue = DispatchQueue.global(qos: qos)
        queue.async {
            DispatchQueue.main.async {
                cell.activityIndicator.startAnimating()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true

            }
            let url = URL(string: Galery.photos[indexPath.row])
            if let niceUrl = url {
                if let data = NSData(contentsOf: niceUrl) {
                    if let img = UIImage(data: data as Data) {
                        DispatchQueue.main.async {
                            cell.imageCell = img
                            cell.activityIndicator.stopAnimating()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: "Cannot access to \(url!)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Cannot access to \(url)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToImage", sender: collectionView.cellForItem(at: indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToImage" {
            let vc = segue.destination as? ImageViewController
            let cell = sender as! CollectionViewCell
            if let dst = vc {
                dst.image = cell.imageCell
            }
        }
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
