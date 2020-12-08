//
//  TakenOrderViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 07/12/2020.
//

import UIKit
import QRCode
import CoreLocation

class TakenOrderViewController: PublishedOrderViewController {

    @IBOutlet weak var qrImage: UIImageView!
    
    
    override func viewDidLoad() {
        setUpUI(order: order)
        generateQR(forOrder: order)
    }
    
    func generateQR(forOrder order: Order) {
        let orderId = order.documentId
        let qr = QRCode(orderId!)
        qrImage.image = qr?.image
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_DIRECTONS {
            if let directionsViewController = segue.destination as? DirectionsViewController {
                directionsViewController.order = self.order
            }
        }
    }
    
}
