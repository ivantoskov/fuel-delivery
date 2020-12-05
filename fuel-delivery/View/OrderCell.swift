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
    @IBOutlet weak var quantityLabel: UILabel!
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return dropPin(mapView: mapView, annotation: annotation, imageName: "gas-pin", pinSize: 40)
    }
    
    func configureCell(forOrder order: Order, userLocation: CLLocation) {
        self.order = order
        nameLabel.text = "Name: " + order.displayName
        fuelLabel.text = "Fuel: " + order.fuelType + " (" + order.quality + ")"
        quantityLabel.text = "Quantity: " + String(order.quantity) + " litres"
        dateLabel.text = "Ending: " + order.deliveryDate
        getDistance(userLocation: CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), order: order) { (distance) in
            self.distanceLabel.text = String(format: "%.1f", distance) + "km from you"
        }
        configureOrderMap(mapView: mapView, location: CLLocation(latitude: order.latitude, longitude: order.longitude))
        
    }
    
    func configureCell(forMyOrder order: Order) {
        self.order = order
        fuelLabel.text = "Fuel: " + order.fuelType + " (" + order.quality + ")"
        quantityLabel.text = "Quantity: " + String(order.quantity) + " litres"
        dateOrderedLabel.text = "Ordered on: " + order.dateOrdered
        statusLabel.text = "Status: " + order.status
        configureOrderMap(mapView: mapView, location: CLLocation(latitude: order.latitude, longitude: order.longitude))
    }
}

