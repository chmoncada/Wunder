//
//  WunderViewController.swift
//  Wunder
//
//  Created by Charles Moncada on 28/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit
import CoreData
import MapKit

protocol WunderViewControllerProtocol: class {
	func reloadData()
	func showError(_ error: NSError?)
}

class WunderViewController: UIViewController {
	public static func create(coreDataStack: CoreDataStackProtocol) -> WunderViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! WunderViewController
		let presenter = WunderPresenter(view: viewController, coreDataStack: coreDataStack)
		viewController.presenter = presenter
		return viewController
	}

	var presenter: WunderPresenterProtocol!

	@IBOutlet weak var tableView: UITableView!

	@IBOutlet weak var mapView: MKMapView!
	let locationManager = CLLocationManager()

	override func viewDidLoad() {
		super.viewDidLoad()

		mapView.isHidden = false
		tableView.isHidden = true

		presenter.viewDidLoad()

		setupMapView()
	}

	@IBAction func toggleView(_ sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			mapView.isHidden = false
			tableView.isHidden = true
		case 1:
			tableView.isHidden = false
			mapView.isHidden = true
		default:
			fatalError("not a valid index")
		}
	}
}

extension WunderViewController: WunderViewControllerProtocol {
	func reloadData() {
		tableView.reloadData()
		mapView.addAnnotations(presenter.items)
	}

	func showError(_ error: NSError?) {
		let title = "Error"
		if let error = error {
			showError(title, message: error.localizedDescription)
		} else {
			showError(title, message: NSLocalizedString("Can't retrieve car info.", comment: "Can't retrieve car info."))
		}
	}
}
