//
//  DirectionsViewController.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 08/12/2020.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation!
    
    var order: Order!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation(locationManager: locationManager)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
        configureDirectionsMap(mapView: mapView, userLocation: userLocation, order: order)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        dropPin(mapView: mapView, annotation: annotation, imageName: "pin", pinSize: 50)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = #colorLiteral(red: 0.3450980392, green: 0.7058823529, blue: 0.6823529412, alpha: 1)
        return renderer
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
