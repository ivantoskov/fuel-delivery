//
//  MyOrderDetailsViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 05/12/2020.
//

import UIKit
import CoreLocation
import Firebase

class MyOrderDetailsViewController: PublishedOrderViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var acceptedByLabel: UILabel!
    
    private var usersListener: ListenerRegistration!

    override func viewDidLoad() {
        super.viewDidLoad()
        getAcceptor(order: order)
        setUpUI(order: order)
    }
    
    override func setUpUI(order: Order) {
        addressLabel.text = order.address
        fuelLabel.text = order.fuelType + " (" + order.quality + ")"
        totalCostLabel.text = String(order.totalCost.rounded(.up)) + "$"
        deliveryTimeLabel.text = order.deliveryDate
        statusLabel.text = order.status
        configureOrderMap(mapView: mapView, location: CLLocation(latitude: order.latitude, longitude: order.longitude))
    }
    
    func getAcceptor(order: Order) {
        if order.status == ACCEPTED {
            guard let userId = order.acceptedBy else { return }
            usersListener = Firestore.firestore().collection(USERS_REF).document(userId).addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {
                    let user = User.parseData(snapshot: snapshot)
                    self.acceptedByLabel.text = user.displayName
                }
            })
        } else {
            self.acceptedByLabel.text = "Nobody"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_SCAN_QR {
            if let scanViewController = segue.destination as? QRScannerViewController {
                scanViewController.order = self.order
            }
        }
    }
    
    
}
