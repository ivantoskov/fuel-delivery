//
//  TakenOrdersViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 02/12/2020.
//

import UIKit
import Firebase
import MapKit

class TakenOrdersViewController: BaseOrderViewController {
    
    var userLat: Double!
    var userLon: Double!
    
    var userLocation: CLLocation! // ?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setListener() {
        ordersListener = ordersCollectionRef.whereField(ACCEPTED_BY_USER, isEqualTo: Auth.auth().currentUser!.uid)
            .order(by: DATE_ORDERED, descending: true)
            .addSnapshotListener { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            } else {
                self.orders.removeAll()
                self.orders = Order.parseData(snapshot: snapshot)
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ORDER_CELL, for: indexPath) as? OrderCell {
            cell.configureCell(forOrder: orders[indexPath.row], lat: userLocation.coordinate.latitude, lon: userLocation.coordinate.longitude)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
