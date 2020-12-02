//
//  NearbyOrdersViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 30/11/2020.
//

import UIKit
import MapKit
import Firebase

class NearbyOrdersViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var orders = [Order]()
    private var ordersListener: ListenerRegistration!
    private var ordersCollectionRef: CollectionReference!
    private var handle: AuthStateDidChangeListenerHandle?
    
    var userLat: Double!
    var userLon: Double!
    var userLocality: String!
    var userCountry: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        /* Dynamicly resizing UITableViewCell */
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        
        ordersCollectionRef = Firestore.firestore().collection(ORDERS_REF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if Auth.auth().currentUser == nil {
                let storboard = UIStoryboard(name: MAIN, bundle: nil)
                let loginVC = storboard.instantiateViewController(withIdentifier: SIGN_IN_VC)
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if ordersListener != nil {
            ordersListener.remove()
        }
    }
    
    func setListener() {
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
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension NearbyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ORDER_CELL, for: indexPath) as? OrderCell {
            cell.configureCell(order: orders[indexPath.row], lat: userLat, lon: userLon)
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
