//
//  ViewController+MapKit.swift
//  Wunder
//
//  Created by Charles Moncada on 30/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit
import MapKit

extension WunderViewController {
	func setupMapView() {
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		determineCurrentLocation()

		mapView.showsUserLocation = true
		mapView.userLocation.title = nil
		mapView.delegate = self
	}

	private func determineCurrentLocation() {
		if CLLocationManager.locationServicesEnabled() {
			locationManager.requestLocation()
		}
	}

	private func centerMap(at center: CLLocationCoordinate2D) {
		let regionRadius: CLLocationDistance = 1000
		let region = MKCoordinateRegionMakeWithDistance(center, regionRadius, regionRadius)
		mapView.setRegion(region, animated: true)
		mapView.delegate = self
	}
}

extension WunderViewController: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? Car else { return nil }

		let identifier = "car"
		var view: MKAnnotationView

		if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
			dequeuedView.annotation = annotation
			view = dequeuedView
		} else {
			view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			view.canShowCallout = true
		}

		let image = UIImage(named: "car")
		view.image = image

		return view
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		mapView.annotations
			.filter( { annotation in
				guard let annotation = annotation as? Car else { return false } // Avoid user location
				return !annotation.isEqual(view.annotation)
			})
			.forEach({ mapView.view(for: $0)?.isHidden = true })
	}

	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		mapView.annotations
			.filter( { annotation in
				guard let annotation = annotation as? Car else { return false } // Avoid user location
				return !annotation.isEqual(view.annotation)
			})
			.forEach({ mapView.view(for: $0)?.isHidden = false })
	}
}

extension WunderViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			centerMap(at: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Failed to find user's location: \(error.localizedDescription)")
	}
}

extension Car: MKAnnotation {
	public var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}

	public var title: String? {
		return name
	}
}
