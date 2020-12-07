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
    
    func findPlacemark(fromLocation location: CLLocation, doneSearching: @escaping (_ topResult: CLPlacemark) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarksArray, error) in
            if (error) == nil {
                if placemarksArray!.count > 0 {
                    let placemark = placemarksArray?[0]
                    doneSearching(placemark ?? CLPlacemark())
                }
            }
        }
    }
    
    func findPlacemark(fromAddress address: String, doneSearching: @escaping (_ topResult: CLPlacemark) -> Void) {
        let geocode = CLGeocoder()
        geocode.geocodeAddressString(address) { (placemarksArray, error) in
            if (error) != nil {
                if placemarksArray!.count > 0 {
                    let placemark = placemarksArray?[0]
                    doneSearching(placemark ?? CLPlacemark())
                }
            }
        }
    }
    
    func getAddress(fromLocation location: CLLocation, completionHandler: @escaping (_ address: String) -> Void) {
        self.findPlacemark(fromLocation: location) { (placemark) in
            let thoroughfare = placemark.thoroughfare ?? ""
            let locality = placemark.locality ?? ""
            let subLocality = placemark.subLocality ?? ""
            let administrativeArea = placemark.administrativeArea ?? ""
            let postalCode = placemark.postalCode ?? ""
            let country = placemark.country ?? ""
            let addressArray = [thoroughfare, locality, subLocality, administrativeArea, postalCode, country]
            var addressStr = ""
            for str in addressArray {
                if (str != "") {
                    addressStr += "\(str), "
                }
             }
            completionHandler(addressStr)
        }
    }
    
    func getLocation(fromAddress address: String, completionHandler: @escaping (_ location: CLLocation) -> Void) {
        self.findPlacemark(fromAddress: address) { (placemark) in
            let latitude = placemark.location?.coordinate.latitude ?? 0.0
            let longitude = placemark.location?.coordinate.longitude ?? 0.0
            let location = CLLocation(latitude: latitude, longitude: longitude)
            completionHandler(location)
        }
    }
    
}
