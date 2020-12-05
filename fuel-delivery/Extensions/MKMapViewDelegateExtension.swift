//
//  MKMapViewDelegateExtension.swift
//  fuel-delivery
//
//  Created by Ivan Toskov on 04/12/2020.
//

import Foundation
import MapKit

extension MKMapViewDelegate {
    
    func configureOrderMap(mapView: MKMapView, location: CLLocation) {
        mapView.delegate = self
        let orgLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = orgLocation
        mapView.addAnnotation(dropPin)
        mapView.setRegion(MKCoordinateRegion(center: orgLocation, latitudinalMeters: 250, longitudinalMeters: 250), animated: true)
        mapView.layer.cornerRadius = 10.0
    }
    
    func configureMainMap(mapView: MKMapView, location: CLLocation, nearbyOrders: [Order]) {
        mapView.delegate = self
        if nearbyOrders.count > 0 {
            for order in nearbyOrders {
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = CLLocationCoordinate2D(latitude: order.latitude, longitude: order.longitude)
                dropPin.title = "\(order.fuelType!) (\(order.quality!))"
                dropPin.subtitle = "\(order.quantity!) litres"
                mapView.addAnnotation(dropPin)
            }
        }
        let orgLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        mapView.setRegion(MKCoordinateRegion(center: orgLocation, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: true)
        mapView.showsUserLocation = true
    }
    
    func dropPin(mapView: MKMapView, annotation: MKAnnotation, imageName: String, pinSize: Double) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomPin")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomPin")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        let pinImage = UIImage(named: imageName)
        let size = CGSize(width: pinSize, height: pinSize)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        return annotationView
    }
    
    func calculateDistancefrom(sourceLocation: MKMapItem, destinationLocation: MKMapItem, doneSearching: @escaping (_ expectedTravelTim: TimeInterval) -> Void) {

        let request: MKDirections.Request = MKDirections.Request()

            request.source = sourceLocation
            request.destination = destinationLocation
            request.requestsAlternateRoutes = true
            request.transportType = .automobile

            let directions = MKDirections(request: request)
            directions.calculate { (directions, error) in

                if var routeResponse = directions?.routes {
                    routeResponse.sort(by: {$0.expectedTravelTime <
                        $1.expectedTravelTime})
                    let quickestRouteForSegment: MKRoute = routeResponse[0]

                    doneSearching(quickestRouteForSegment.distance)

                }
            }
    }
    
    func getDistance(userLocation: CLLocation, order: Order, completionHandler: @escaping (_ distance: Double) -> Void) {

        let destinationItem =  MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(order.latitude, order.longitude)))
            let currentLocation = userLocation
            let sourceItem =  MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
                self.calculateDistancefrom(sourceLocation: sourceItem, destinationLocation: destinationItem, doneSearching: { distance in
                    completionHandler(distance / 1000)
                })
        }
}
