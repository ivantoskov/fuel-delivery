//
//  BaseOrderViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 03/12/2020.
//

import UIKit
import Firebase

class BaseOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet internal weak var tableView: UITableView!
    
    internal var orders = [Order]()
    internal var ordersListener: ListenerRegistration!
    internal var ordersCollectionRef: CollectionReference!
    internal var handle: AuthStateDidChangeListenerHandle?
    
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
    
    func setListener() {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
