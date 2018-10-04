//
//  CarManagerTests.swift
//  WunderTests
//
//  Created by Charles Moncada on 02/10/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import XCTest
import CoreData

@testable import Wunder

class CarManagerTests: XCTestCase {

	var sut: CarManager!
	let coreDataStack: CoreDataStackProtocol = MockCoreDataStack()
	lazy var mockURLSession = URLSessionMock()

	override func setUp() {
		super.setUp()

		var data: Data? = nil
		let bundle = Bundle(for: type(of: self))
		if let url = bundle.url(forResource: "locations", withExtension: "json") {
			do {
				data = try Data(contentsOf: url)
			} catch let error {
				print(error.localizedDescription)
			}
		}
		mockURLSession.data = data

		sut = CarManager(coreDataStack: coreDataStack, session: mockURLSession)

		//Listen to the change in context
		NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave , object: nil)
	}

	override func tearDown() {

		NotificationCenter.default.removeObserver(self)

		flushData()

		super.tearDown()
	}

	func testFetchCarData() {

		let expectation = XCTestExpectation(description: "Fetch Car Data")

		sut.fetchCarData { result in
			switch result {
			case .success(let cars):
				XCTAssertEqual(3, cars.count)
				expectation.fulfill()
			case .error:
				expectation.isInverted = true
			}
		}

		wait(for: [expectation], timeout: 10.0)

	}

	func testFetchWrongCarData() {

		let expectation = XCTestExpectation(description: "Fetch Wrong Car Data")

		var data: Data? = nil
		let bundle = Bundle(for: type(of: self))
		if let url = bundle.url(forResource: "wrongLocations", withExtension: "json") {
			do {
				data = try Data(contentsOf: url)
			} catch {
				expectation.isInverted = true
			}
		}
		mockURLSession.data = data

		sut = CarManager(coreDataStack: coreDataStack, session: mockURLSession)

		sut.fetchCarData { result in
			switch result {
			case .success:
				expectation.isInverted = true
			case .error(let error):
				XCTAssertEqual("JSON parsing error", error?.localizedDescription)
				expectation.fulfill()
			}
		}

		wait(for: [expectation], timeout: 10.0)

	}

	//MARK: Convinient function for notification
	var saveNotificationCompleteHandler: ((Notification)->())?

	func expectationForSaveNotification() -> XCTestExpectation {
		let expect = expectation(description: "Context Saved")
		waitForSavedNotification { (notification) in
			expect.fulfill()
		}
		return expect
	}

	func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
		saveNotificationCompleteHandler = completeHandler
	}

	func contextSaved( notification: Notification ) {
		saveNotificationCompleteHandler?(notification)
	}
}

extension CarManagerTests {

	func flushData() {
		let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
		let objs = try! coreDataStack.managedContext.fetch(fetchRequest)
		for case let obj as NSManagedObject in objs {
			coreDataStack.managedContext.delete(obj)
		}

		coreDataStack.saveContext()
	}

	func numberOfItemsInPersistentStore() -> Int {
		let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Car")
		let results = try! coreDataStack.managedContext.fetch(request)
		return results.count
	}
}

extension CarManagerTests {
	//MARK: mock in-memory CoreDataStack
	class MockCoreDataStack: CoreDataStackProtocol {

		var managedContext: NSManagedObjectContext {
			return storeContainer.viewContext
		}

		func saveContext() {
			guard managedContext.hasChanges else { return }

			do {
				try managedContext.save()
			} catch let error as NSError {
				print("Unresolved error \(error), \(error.userInfo)")
			}
		}

		lazy var managedObjectModel: NSManagedObjectModel = {
			let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
			return managedObjectModel
		}()

		lazy var storeContainer: NSPersistentContainer = {

			let container = NSPersistentContainer(name: "Wunder", managedObjectModel: self.managedObjectModel)
			let description = NSPersistentStoreDescription()
			description.type = NSInMemoryStoreType
			description.shouldAddStoreAsynchronously = false // Make it simpler in test env

			container.persistentStoreDescriptions = [description]
			container.loadPersistentStores { (description, error) in
				// Check if the data store is in memory
				precondition( description.type == NSInMemoryStoreType )

				// Check if creating container wrong
				if let error = error {
					fatalError("Create an in-mem coordinator failed \(error)")
				}
			}
			return container
		}()
	}

	class URLSessionMock: URLSession {
		typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

		var data: Data?
		var error: Error?

		override func dataTask(
			with request: URLRequest,
			completionHandler: @escaping CompletionHandler)
			-> URLSessionDataTask {
				let data = self.data
				let error = self.error
				return URLSessionDataTaskMock {
					completionHandler(data, nil, error)
				}
		}
	}

	class URLSessionDataTaskMock: URLSessionDataTask {
		private let closure: () -> Void
		init(closure: @escaping () -> Void) {
			self.closure = closure
		}

		override func resume() {
			closure()
		}
	}
}
