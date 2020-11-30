//
//  MainViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 29/11/2020.
//

import UIKit
import MapKit
import Firebase

class MainViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var locationLabel: UILabel!
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocation!
    private var handle: AuthStateDidChangeListenerHandle?
    
    private var userLat = 0.0
    private var userLon = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
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
                //self.setListener()
                print ("logged in")
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        mapView.setRegion(region, animated: true)
        getAddress(location: userLocation)
        mapView.showsUserLocation = true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error - locationManager: \(error.localizedDescription)")
    }

    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func getAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarksArray, error) in
            print(placemarksArray!)
            if (error) == nil {
                if placemarksArray!.count > 0 {
                    let placemark = placemarksArray?[0]
                    let address = "\(placemark?.thoroughfare ?? ""), \(placemark?.locality ?? ""), \(placemark?.subLocality ?? ""), \(placemark?.administrativeArea ?? ""), \(placemark?.postalCode ?? ""), \(placemark?.country ?? "")"
                    self.locationLabel.text = address
                }
            }
        }
        userLat = userLocation.coordinate.latitude
        userLon = userLocation.coordinate.longitude
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        // For now it will just sign out the user
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_ORDER {
            if let orderViewController = segue.destination as? OrderViewController {
                orderViewController.userLat = self.userLat
                orderViewController.userLon = self.userLon
                orderViewController.userAddress = self.locationLabel.text!
            }
        }
    }
}
