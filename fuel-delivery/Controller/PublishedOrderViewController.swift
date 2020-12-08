//
//  PublishedOrderViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 30/11/2020.
//

import UIKit
import MapKit
import Firebase
import SCLAlertView

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
        getDistance(userLocation: CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), order: order) { (distance) in
            self.distanceLabel.text = String(format: "%.1f", distance) + "km"
        }
        configureOrderMap(mapView: mapView, location: CLLocation(latitude: order.latitude, longitude: order.longitude))
    }
    
    func setUpUI(order: Order) {
        nameLabel.text = order.displayName.uppercased() + "'S ORDER"
        addressLabel.text = order.address
        fuelLabel.text = order.fuelType + " (" + order.quality + ")"
        totalCostLabel.text = String(order.totalCost.rounded(.up)) + "$"
        deliveryTimeLabel.text = order.deliveryDate
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        dropPin(mapView: mapView, annotation: annotation, imageName: "pin", pinSize: 50)
    }
    
    func takeOrder() {
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
    
    @IBAction func takeOrderPressed(_ sender: Any) {
        let alertView = SCLAlertView()
        alertView.addButton("Take") {
            self.takeOrder()
        }
        alertView.showSuccess("Take Order?", subTitle: "Are you sure that you want to take this order?", closeButtonTitle: "Cancel" , timeout: nil, colorStyle: SCLAlertViewStyle.success.defaultColorInt, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
        }
}
