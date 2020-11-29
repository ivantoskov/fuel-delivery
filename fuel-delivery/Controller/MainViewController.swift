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
    @IBOutlet weak var fuelSegment: UISegmentedControl!
    
    var locationManager: CLLocationManager!
    var userLocation: CLLocation!
    private var handle: AuthStateDidChangeListenerHandle?
    
    private var selectedFuel = FuelType.petrol.rawValue
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
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let signInVC = storyboard.instantiateViewController(withIdentifier: "signInVC")
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
    
    @IBAction func fuelChanged(_ sender: Any) {
        switch fuelSegment.selectedSegmentIndex {
        case 0:
            selectedFuel = FuelType.petrol.rawValue
        case 1:
            selectedFuel = FuelType.diesel.rawValue
        case 2:
            selectedFuel = FuelType.engineOil.rawValue
        default:
            selectedFuel = FuelType.petrol.rawValue
        }
    }
    
    @IBAction func orderPressed(_ sender: Any) {
       /* Firestore.firestore().collection(ORDERS_REF).addDocument(data: [
            FUEL_TYPE : selectedFuel,
            TIMESTAMP : FieldValue.serverTimestamp(),
            DISPLAY_NAME : Auth.auth().currentUser?.displayName ?? "",
            USER_ID : Auth.auth().currentUser?.uid ?? "",
            LATITUDE : userLat,
            LONGITUDE: userLon,
            ADDRESS: locationLabel.text!
        ]) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } */
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
    
    
}
