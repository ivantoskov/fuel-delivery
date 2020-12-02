//
//  NearbyOrdersViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 30/11/2020.
//

import UIKit
import MapKit
import Firebase

class NearbyOrdersViewController: BaseOrderViewController {

    var userLat: Double!
    var userLon: Double!
    var userLocality: String!
    var userCountry: String!
    
    override func setListener() {
        ordersListener = ordersCollectionRef.whereField(STATUS, isEqualTo: ORDERED)
            .whereField(LOCALITY, isEqualTo: self.userLocality!)
            .whereField(COUNTRY, isEqualTo: self.userCountry!)
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
            cell.configureCell(forOrder: orders[indexPath.row], lat: userLat, lon: userLon)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: TO_PUBLISHED_ORDER, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_PUBLISHED_ORDER {
            if let publishedOrderViewController = segue.destination as? PublishedOrderViewController {
                publishedOrderViewController.order = orders[(tableView.indexPathForSelectedRow?.row)!]
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            }
        }
    }
    
}
