//
//  Mapa.swift
//  AireAMG
//
//  Created by Alan Garcia on 9/25/16.
//  Copyright © 2016 ShadowForge. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Mapa: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    
    @IBOutlet weak var Menu: UIBarButtonItem!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var variable:String?
    
    let locationManager = CLLocationManager()
    //https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/
    
    
    
    
    override func viewDidLoad() {
        
        Menu.target = self.revealViewController()
        Menu.action = Selector("revealToggle:")
        
        
        
        
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        NSLog(variable!);
        
        /*locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true*/
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()   //io9
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        
    }
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors" + error.localizedDescription)
    }
    
    
    
}






