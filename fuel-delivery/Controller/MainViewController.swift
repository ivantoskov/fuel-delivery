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
            } else {
                //
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 250, longitudinalMeters: 250)

        configureMainMap(mapView: mapView, region: region)
        getAddress(fromLocation: userLocation)
        
        let hash = Geohash.encode(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, length: 4)
        
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
                    let address = "\(placemark?.thoroughfare ?? "") \(placemark?.locality ?? "") \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? "") \(placemark?.postalCode ?? "") \(placemark?.country ?? "")"
                    self.locationLabel.text = address
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
