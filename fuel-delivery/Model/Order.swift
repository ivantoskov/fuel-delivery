//
//  Order.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import Foundation
import Firebase

class Order {
    
    private(set) var firstName: String!
    private(set) var lastName: String!
    private(set) var timestamp: Date!
    private(set) var userId: String!
    private(set) var fuelType: String!
    private(set) var documentId: String!
    private(set) var latitude: Double!
    private(set) var longitude: Double!
    private(set) var address: String!
    
    init(firstName: String, lastName: String, timestamp: Date, userId: String, fuelType: String, documentId: String, latitude: Double, longitude: Double, address: String!) {
        self.firstName = firstName
        self.lastName = lastName
        self.timestamp = timestamp
        self.userId = userId
        self.fuelType = fuelType
        self.documentId = documentId
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
    
    class func parseDat(snapshot: QuerySnapshot?) -> [Order] {
        var orders = [Order]()
        guard let snap = snapshot else { return orders }
        for document in snap.documents {
            let data = document.data()
            let firstName = data[FIRST_NAME] as? String ?? "Anonymous"
            let lastName = data[LAST_NAME] as? String ?? ""
            let timestamp = data[TIMESTAMP] as? Date ?? Date()
            let documentId = document.documentID
            let userId = data[USER_ID] as? String ?? ""
            let fuelType = data[FUEL_TYPE] as? String ?? ""
            let latitude = data[LATITUDE] as? Double ?? 0.0
            let longitude = data[LONGITUDE] as? Double ?? 0.0
            let address = data[ADDRESS] as? String ?? ""
            let newOrder = Order(firstName: firstName, lastName: lastName, timestamp: timestamp, userId: userId, fuelType: fuelType, documentId: documentId, latitude: latitude, longitude: longitude, address: address)
            orders.append(newOrder)
        }
        return orders
    }
    
}
