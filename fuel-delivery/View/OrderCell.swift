//
//  OrderCell.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 30/11/2020.
//

import UIKit
import MapKit
import Firebase

class OrderCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var QuantityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateOrderedLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var order: Order!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureMap(lat: Double, lon: Double) {
        if let mapView = self.mapView {
            mapView.delegate = self
        }
        let orgLocation = CLLocationCoordinate2DMake(lat, lon)

        let dropPin = MKPointAnnotation()
        dropPin.coordinate = orgLocation
        mapView!.addAnnotation(dropPin)

        self.mapView?.setRegion(MKCoordinateRegion(center: orgLocation, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
    }
    
    func getDistanceInKm(order: Order, myLat: Double, myLon: Double) -> Double {
        self.order = order
        let earthRadius = 6371.0
        let dLat = deg2rad(deg: order.latitude - myLat)
        let dLon = deg2rad(deg: order.longitude - myLon)
        let a = sin(dLat / 2) * sin(dLat / 2) +
            cos(deg2rad(deg: myLat)) * cos(deg2rad(deg: order.latitude)) *
                sin(dLon / 2) * sin(dLon / 2)
        
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))
        let distance = earthRadius * c
        return distance
    }

    func deg2rad(deg: Double) -> Double {
        return deg * (Double.pi / 180.0)
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d YYYY"
        let timestamp = formatter.string(from: date)
        return timestamp
    }
    
    func configureCell(order: Order, lat: Double, lon: Double) {
        self.order = order
        nameLabel.text = "Name: " + order.displayName
        fuelLabel.text = "Fuel: " + order.fuelType + " (" + order.quality + ")"
        QuantityLabel.text = "Quantity: " + String(order.quantity) + " litres"
        dateLabel.text = "Ending: " + order.deliveryDate
        distanceLabel.text = String(format: "%.1f", getDistanceInKm(order: order, myLat: lat, myLon: lon)) + "km from you"
        configureMap(lat: order.latitude, lon: order.longitude)
        
    }
    
    func configureMyOrderCell(order: Order) {
        self.order = order
        fuelLabel.text = "Fuel: " + order.fuelType + " (" + order.quality + ")"
        QuantityLabel.text = "Quantity: " + String(order.quantity) + " litres"
        dateOrderedLabel.text = "Ordered on: " + dateToString(date: order.dateOrdered)
        statusLabel.text = "Status: " + order.status
        configureMap(lat: order.latitude, lon: order.longitude)
    }
}
