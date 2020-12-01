//
//  MyOrdersViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 01/12/2020.
//

import UIKit
import Firebase

class MyOrdersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var orders = [Order]()
    private var ordersListener: ListenerRegistration!
    private var ordersCollectionRef: CollectionReference!
    private var handle: AuthStateDidChangeListenerHandle?
    
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
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MyOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ORDER_CELL, for: indexPath) as? OrderCell {
            cell.configureMyOrderCell(order: orders[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: TO_PUBLISHED_ORDER, sender: self)
    }
}
