//
//  ViewController.swift
//  Memorable Places
//
//  Created by Vanessa Chu on 2017-07-02.
//  Copyright © 2017 Vanessa Chu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var map: MKMapView!
    var activeRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if place[activeRow]["name"] != nil{
            if place[activeRow]["lat"] != nil{
                if place[activeRow]["lon"] != nil{
                    let deltaLong: CLLocationDegrees = 0.05
                    let deltaLat: CLLocationDegrees = 0.05
                    let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLong)
                    let latitude: CLLocationDegrees = Double(place[activeRow]["lat"]!)!
                    let longitude: CLLocationDegrees = Double(place[activeRow]["lon"]!)!
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
                    map.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = place[activeRow]["name"]
                    annotation.coordinate = location
                    map.addAnnotation(annotation)
                }
            }
        }
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        map.addGestureRecognizer(uilpgr)
        
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: self.map)
        let coordinate = map.convert(touchPoint, toCoordinateFrom: self.map)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        map.addAnnotation(annotation)
        
        let location: CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location){(placemarks, error) in
            if error != nil{
                print(error)
            }else{
                if let placemark = placemarks?[0]{
                    
                    var address = ""
                    
                    if placemark.subThoroughfare != nil {
                        address.append(placemark.subThoroughfare! + " ")
                    }
                    
                    if placemark.thoroughfare != nil{
                        address.append(placemark.thoroughfare! + " ")
                    }
                    
                    
                    if address != ""{
                        place.append(["name":address, "lat":String(location.coordinate.latitude), "lon":String(location.coordinate.longitude)])
                        annotation.title = address
                    }
                }
            }
        }
        
        UserDefaults.standard.set(place, forKey: "place")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

