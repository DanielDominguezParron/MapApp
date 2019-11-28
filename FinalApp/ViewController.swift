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
    
    @IBOutlet weak var adressLabel: UILabel!
    let locationManager = CLLocationManager()
     var previousLocation: CLLocation?
    
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
            startTackingUserLocation()
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
    func startTackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
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
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard case let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            
            DispatchQueue.main.async {
                self?.adressLabel.text = "\(streetNumber) \(streetName)"
            }
        }
}
}
