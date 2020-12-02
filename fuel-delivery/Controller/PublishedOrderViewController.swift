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
        configureMap(lan: order.latitude, lon: order.longitude)
    }
    
    func configureMap(lan: Double, lon: Double) {
        if let mapView = self.mapView {
            mapView.delegate = self
        }
        let orgLocation = CLLocationCoordinate2DMake(lan, lon)

        let dropPin = MKPointAnnotation()
        dropPin.coordinate = orgLocation
        mapView!.addAnnotation(dropPin)

        self.mapView?.setRegion(MKCoordinateRegion(center: orgLocation, latitudinalMeters: 250, longitudinalMeters: 250), animated: true)
        
        mapView.layer.cornerRadius = 10.0
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "CustomPin")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomPin")
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        let pinImage = UIImage(named: "gas-pin")
        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        return annotationView
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
