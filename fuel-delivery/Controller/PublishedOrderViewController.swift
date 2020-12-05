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
    @IBOutlet weak var takeOrderButton: UIButton!
    
    var order: Order!
    var userLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI(order: order)
    }
    
    func setUpUI(order: Order) {
        if (order.userId == Auth.auth().currentUser!.uid) {
            takeOrderButton.isHidden = true
            print ("That's your order!")
        }
        nameLabel.text = order.displayName.uppercased() + "'S ORDER"
        addressLabel.text = order.address
        distanceLabel.text = String(format: "%.1f", getDistance(fromLocation: CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), toOrder: order)) + "km from you"
        fuelLabel.text = order.fuelType + " (" + order.quality + ")"
        totalCostLabel.text = String(order.totalCost.rounded(.up)) + "$"
        deliveryTimeLabel.text = order.deliveryDate
        configureOrderMap(mapView: mapView, location: CLLocation(latitude: order.latitude, longitude: order.longitude))
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        dropPin(mapView: mapView, annotation: annotation, imageName: "gas-pin", pinSize: 50)
    }
    
    @IBAction func takeOrderPressed(_ sender: Any) {

            Firestore.firestore().collection(ORDERS_REF).document(order.documentId)
                .updateData([
                    STATUS: ACCEPTED,
                    ACCEPTED_BY_USER: Auth.auth().currentUser!.uid])
                { (error) in
                    if let error = error {
                        debugPrint("Unable to update data: \(error.localizedDescription)")
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
        }
}
