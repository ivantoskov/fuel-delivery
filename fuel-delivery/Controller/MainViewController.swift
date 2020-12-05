//
//  MainViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import UIKit
import MapKit
import Firebase

class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var locationLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocation!
    
    private var handle: AuthStateDidChangeListenerHandle?
    private var ordersListener: ListenerRegistration!
    private var ordersCollectionRef: CollectionReference!
    
    private var nearbyOrders = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation(locationManager: locationManager)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkIfSignedIn()
    }
    
    func checkIfSignedIn() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if Auth.auth().currentUser == nil {
                let storyboard = UIStoryboard(name: MAIN, bundle: nil)
                let signInVC = storyboard.instantiateViewController(withIdentifier: SIGN_IN_VC)
                signInVC.modalPresentationStyle = .fullScreen
                self.present(signInVC, animated: true, completion: nil)
            }
        })
    }
    
    func setListener() {
        let userHash = Geohash.encode(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, length: 3)
        ordersListener = Firestore.firestore().collection(ORDERS_REF)
            .whereField(STATUS, isEqualTo: ORDERED)
            .whereField(GEO_HASH, isEqualTo: userHash)
            .order(by: DATE_ORDERED, descending: true)
            .addSnapshotListener { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            } else {
                self.nearbyOrders.removeAll()
                self.nearbyOrders = Order.parseData(snapshot: snapshot)
                self.configureMainMap(mapView: self.mapView, location: self.userLocation, nearbyOrders: self.nearbyOrders)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        getAddress(fromLocation: userLocation)
        self.setListener()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        dropPin(mapView: mapView, annotation: annotation, imageName: "gas-pin", pinSize: 50)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func getAddress(fromLocation location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarksArray, error) in
            if (error) == nil {
                if placemarksArray!.count > 0 {
                    let placemark = placemarksArray?[0]
                    let thoroughfare = placemark?.thoroughfare ?? ""
                    let locality = placemark?.locality ?? ""
                    let subLocality = placemark?.subLocality ?? ""
                    let administrativeArea = placemark?.administrativeArea ?? ""
                    let postalCode = placemark?.postalCode ?? ""
                    let country = placemark?.country ?? ""
                    let addressArray = [thoroughfare, locality, subLocality, administrativeArea, postalCode, country]
                    var addressStr = ""
                    for str in addressArray {
                        if (str != "") {
                            addressStr += "\(str), "
                        }
                    }
                    self.locationLabel.text = addressStr
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_NEW_ORDER {
            if let newOrderViewController = segue.destination as? NewOrderViewController {
                newOrderViewController.userLocation = self.userLocation
                newOrderViewController.userAddress = self.locationLabel.text!
            }
        }
        
        if segue.identifier == TO_NEARBY_ORDERS {
            if let nearbyOrdersViewController = segue.destination as? NearbyOrdersViewController {
                nearbyOrdersViewController.userLocation = self.userLocation
            }
        }
        
        if segue.identifier == TO_PROFILE {
            if let profileViewController = segue.destination as? ProfileViewController {
                profileViewController.userLocation = self.userLocation
            }
        }
    }
}
