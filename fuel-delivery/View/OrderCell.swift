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
    
    private var order: Order!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
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
    
    func configureCell(order: Order, lat: Double, lon: Double) {
        self.order = order
        nameLabel.text = order.displayName
        fuelLabel.text = order.fuelType + "(" + order.quality + ")"
        QuantityLabel.text = String(order.quantity) + " litres"
        dateLabel.text = order.deliveryDate
        configureMap(lat: order.latitude, lon: order.longitude)
        distanceLabel.text = "\(Int(getDistanceInKm(order: order, myLat: lat, myLon: lon))) km from you"
    }
}