//
//  Location.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 10/12/2020.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
