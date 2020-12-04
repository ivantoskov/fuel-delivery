//
//  CLLocationManagerDelegateExtension.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 04/12/2020.
//

import Foundation
import CoreLocation

extension CLLocationManagerDelegate {
    
    func determineCurrentLocation(locationManager: CLLocationManager) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}
