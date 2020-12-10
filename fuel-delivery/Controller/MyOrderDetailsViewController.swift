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
    
    @IBOutlet weak var acceptedByLabel: UILabel!
    @IBOutlet weak var orderedView: CircleView!
    @IBOutlet weak var orderedLabel: UILabel!
    @IBOutlet weak var acceptedView: CircleView!
    @IBOutlet weak var acceptedLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var deliveredView: CircleView!
    @IBOutlet weak var deliveredLabel: UILabel!
    @IBOutlet weak var qrButton: RoundedButton!
    
    private var usersListener: ListenerRegistration!

    override func viewDidLoad() {
        getAcceptor(order: order)
        setUpUI(order: order)
    }
    
    override func setUpUI(order: Order) {
        addressLabel.text = order.address
        fuelLabel.text = order.fuelType + " (" + order.quality + ")"
        totalCostLabel.text = String(order.totalCost.rounded(.up)) + "$"
        deliveryTimeLabel.text = order.deliveryDate
        
        if order.status == ACCEPTED {
            acceptedView.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 0.6823529412, alpha: 1)
            acceptedLabel.textColor = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 0.6823529412, alpha: 1)
            lineView.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 0.6823529412, alpha: 1)
        }
        if order.status == DELIVERED {
            acceptedView.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 0.6823529412, alpha: 1)
            acceptedLabel.textColor = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 0.6823529412, alpha: 1)
            deliveredView.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 0.6823529412, alpha: 1)
            deliveredLabel.textColor = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 0.6823529412, alpha: 1)
            lineView.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 0.6823529412, alpha: 1)
            qrButton.isHidden = true
        }
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
