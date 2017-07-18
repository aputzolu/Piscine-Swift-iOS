//
//  FirstViewController.swift
//  d05
//
//  Created by Anthony PUTZOLU on 6/20/17.
//  Copyright © 2017 Anthony PUTZOLU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ColorPointAnnotation: MKPointAnnotation {
    
    static let colors: [UIColor] = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.purple]
  
}

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapStyle: UISegmentedControl!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let regionRadius: CLLocationDistance = 400
    
    @IBAction func locationButton(_ sender: Any) {
        centerMapOnLocation(location: currentLocation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
        addAnnotations()
        centerMapOnLocation(location: CLLocation(latitude: Data.places[0].2.latitude, longitude: Data.places[0].2.longitude))
        mapStyle.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }

    func addAnnotations() {
        //var custom_image: Bool = true
        //var color: MKPinAnnotationColor = MKPinAnnotationColor.Purple
        for place in Data.places {
            let annotation = ColorPointAnnotation()//(pinColor: UIColor.blue)//ColorPointAnnotation.colors[(Int(arc4random_uniform(UInt32(2))))])
            annotation.title = place.0
            annotation.subtitle = place.1
            annotation.coordinate = place.2
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("ANNO view")
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = ColorPointAnnotation.colors[(Int(arc4random_uniform(UInt32(4))))]
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    func segmentedControlChanged(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location updated !")
        currentLocation = locations.last
        print(currentLocation)
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
            mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue) {
        print(segue.identifier!)
    }
}

//let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
