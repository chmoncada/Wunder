//
//  WunderViewControllerTests.swift
//  WunderTests
//
//  Created by Charles Moncada on 07/10/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import XCTest

@testable import Wunder

class WunderViewTests: XCTestCase {

	var wunderView: WunderViewController!
	var mockPresenter: MockWunderPresenter!

	override func setUp() {
		super.setUp()

		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc: WunderViewController = storyboard.instantiateViewController(withIdentifier: "WunderViewController") as! WunderViewController
		wunderView = vc
		mockPresenter = MockWunderPresenter()
		wunderView.presenter = mockPresenter

		_ = wunderView.view
	}

	override func tearDown() {
		mockPresenter.flushData()
		wunderView.mapView.removeAnnotations(wunderView.mapView.annotations)
		super.tearDown()
	}

	func testViewToggleViewShowList() {

		wunderView.segmentedControl.selectedSegmentIndex = 1
		wunderView.toggleView(wunderView.segmentedControl)

		XCTAssertTrue(wunderView.mapView.isHidden)
		XCTAssertFalse(wunderView.tableView.isHidden)

	}

	func testViewToggleViewShowMap() {

		wunderView.segmentedControl.selectedSegmentIndex = 0
		wunderView.toggleView(wunderView.segmentedControl)

		XCTAssertFalse(wunderView.mapView.isHidden)
		XCTAssertTrue(wunderView.tableView.isHidden)

	}

	func testViewTableShowCorrectNumberOfCarRows() {

		wunderView.reloadData()

		let numberOfRows = wunderView.tableView(wunderView.tableView, numberOfRowsInSection: 0)

		XCTAssertEqual(2, numberOfRows)
	}

	func testViewTableShowCorrectHeightOfRow() {

		wunderView.reloadData()

		let height = wunderView.tableView(wunderView.tableView, heightForRowAt: IndexPath(row: 0, section: 0))

		XCTAssertEqual(120, height)
	}

	func testViewTableShowCorrectCell() {

		wunderView.reloadData()

		let cell = wunderView.tableView(wunderView.tableView, cellForRowAt: IndexPath(row: 0, section: 0))

		XCTAssertNotNil(cell as? CarInfoCardCell)
	}

	func testViewMapviewShowCorrectNumberOfAnnotations() {

		wunderView.reloadData()

		let numberOfAnnotations = wunderView.mapView.annotations
			.filter( { annotation in
				guard annotation is Car else { return false } // Avoid user location
				return true
			}).count

		XCTAssertEqual(2, numberOfAnnotations)
	}

	func testViewMapviewShowCorrectAnnotationView() {

		wunderView.reloadData()

		let firstAnnotation = wunderView.mapView.annotations
			.first(where: { $0.title == "HH-GO9999"} )!

		let annotationView = wunderView.mapView(wunderView.mapView, viewFor: firstAnnotation)!

		XCTAssertEqual(annotationView.annotation?.title, "HH-GO9999")

		let annotationCoordinate = annotationView.annotation?.coordinate

		XCTAssertEqual(annotationCoordinate?.latitude, 52.0)
		XCTAssertEqual(annotationCoordinate?.longitude, 9.1)
	}
}

extension WunderViewTests {
	class MockWunderPresenter: WunderPresenterProtocol {
		var items: [Car] = []

		let mockCoreDataStack = MockCoreDataStack()

		func viewDidLoad() {
			mockCoreDataStack.mockModelSetup()
			fetchFromStorage()
		}

		private func fetchFromStorage() {
			let managedObjectContext = mockCoreDataStack.managedContext
			let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
			do {
				self.items = try managedObjectContext.fetch(fetchRequest)
			} catch let error {
				print(error)
			}
		}

		func flushData() {

			let managedObjectContext = mockCoreDataStack.managedContext
			let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
			let objs = try! managedObjectContext.fetch(fetchRequest)
			for case let obj as NSManagedObject in objs {
				managedObjectContext.delete(obj)
			}
			mockCoreDataStack.saveContext()

		}
	}
}
