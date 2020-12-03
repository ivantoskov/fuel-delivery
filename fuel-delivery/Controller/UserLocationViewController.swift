//
//  UserLocationViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 03/12/2020.
//

import UIKit
import MapKit

class UserLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    internal var locationManager: CLLocationManager!
    internal var userLocation: CLLocation!
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func configureMapView(mapView: MKMapView, region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }

}
