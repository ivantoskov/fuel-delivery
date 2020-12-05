//
//  MyOrdersViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 01/12/2020.
//

import UIKit
import Firebase

class MyOrdersViewController: BaseOrderViewController {
    
    override func setListener() {
        ordersListener = ordersCollectionRef.whereField(USER_ID, isEqualTo: Auth.auth().currentUser!.uid)
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
            cell.configureCell(forMyOrder: orders[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: TO_MY_ORDER_DETAILS, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_MY_ORDER_DETAILS {
            if let myOrderDetailsViewController = segue.destination as? MyOrderDetailsViewController {
                myOrderDetailsViewController.order = orders[(tableView.indexPathForSelectedRow?.row)!]
                tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            }
        }

    }
}
