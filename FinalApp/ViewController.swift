//
//  ViewController.swift
//  FinalApp
//
//  Created by Daniel Domínguez Parrón on 28/11/19.
//  Copyright © 2019 Daniel Domínguez Parrón. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    //Get user location
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Center the view map to the current user location
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            var span = MKCoordinateSpanMake(0.5, 0.5)
            //Creates a new coordinate region from the specified coordinate and distance values.
            let region = MKCoordinateRegion.init(center:location , span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    //Check if gps servies are enabled
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    //Check the authorization
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
            //If the user approves the auth,map start user location
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        var span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion.init(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }


    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServices()
    }
}

