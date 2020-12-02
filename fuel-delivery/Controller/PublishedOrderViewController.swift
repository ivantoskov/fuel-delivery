//
//  PublishedOrderViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 30/11/2020.
//

import UIKit
import MapKit
import Firebase

class PublishedOrderViewController: UIViewController, MKMapViewDelegate  {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    
    var order: Order!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI(order: order)
    }
    
    func setUpUI(order: Order) {
        nameLabel.text = order.displayName.uppercased() + "'S ORDER"
        addressLabel.text = order.address
        fuelLabel.text = order.fuelType + "(" + order.quality + ")"
        totalCostLabel.text = String(order.totalCost.rounded(.up)) + "$"
        deliveryTimeLabel.text = order.deliveryDate
        setUpMap(lan: order.latitude, lon: order.longitude)
    }
    
    func setUpMap(lan: Double, lon: Double) {
        if let mapView = self.mapView {
            mapView.delegate = self
        }
        let orgLocation = CLLocationCoordinate2DMake(lan, lon)

        let dropPin = MKPointAnnotation()
        dropPin.coordinate = orgLocation
        mapView!.addAnnotation(dropPin)

        self.mapView?.setRegion(MKCoordinateRegion(center: orgLocation, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
    }
    
    @IBAction func takeOrderPressed(_ sender: Any) {
        Firestore.firestore().collection(ORDERS_REF).document(order.documentId)
            .updateData([STATUS: ACCEPTED]) { (error) in
                if let error = error {
                    debugPrint("Unable to update comment: \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
}
