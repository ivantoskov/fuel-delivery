//
//  Order.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import Foundation
import Firebase

class Order {
    
    private(set) var displayName: String!
    private(set) var dateOrdered: Date!
    private(set) var userId: String!
    private(set) var fuelType: String!
    private(set) var quality: String!
    private(set) var quantity: Int!
    private(set) var deliveryDate: String! // !!!!
    private(set) var documentId: String!
    private(set) var latitude: Double!
    private(set) var longitude: Double!
    private(set) var address: String!
    private(set) var totalCost: Double!
    
    
    init(displayName: String, dateOrdered: Date, userId: String, fuelType: String, quality: String, quantity: Int, deliveryDate: String, documentId: String, latitude: Double, longitude: Double, address: String, totalCost: Double) {
        self.displayName = displayName
        self.dateOrdered = dateOrdered
        self.userId = userId
        self.fuelType = fuelType
        self.quality = quality
        self.quantity = quantity
        self.deliveryDate = deliveryDate
        self.documentId = documentId
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.totalCost = totalCost
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Order] {
        var orders = [Order]()
        guard let snap = snapshot else { return orders }
        for document in snap.documents {
                let data = document.data()
                let displayName = data[DISPLAY_NAME] as? String ?? ""
                let dateOrdered = data[DATE_ORDERED] as? Date ?? Date()
                let documentId = document.documentID
                let userId = data[USER_ID] as? String ?? ""
                let fuelType = data[FUEL_TYPE] as? String ?? ""
                let quality = data[FUEL_QUALITY] as? String ?? ""
                let quantity = data[QUANTITY] as? Int ?? 0
                let deliveryDate = data[DELIVERY_TIME] as? String ?? ""
                let latitude = data[LATITUDE] as? Double ?? 0.0
                let longitude = data[LONGITUDE] as? Double ?? 0.0
                let address = data[ADDRESS] as? String ?? ""
                let totalCost = data[TOTAL_PRICE] as? Double ?? 0.0
                let newOrder = Order(displayName: displayName, dateOrdered: dateOrdered, userId: userId, fuelType: fuelType, quality: quality, quantity: quantity, deliveryDate: deliveryDate, documentId: documentId, latitude: latitude, longitude: longitude, address: address, totalCost: totalCost)
                orders.append(newOrder)
        }
        return orders
    }
    
}
