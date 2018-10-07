//
//  CoreDataHelper.swift
//  WunderTests
//
//  Created by Charles Moncada on 07/10/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import CoreData

@testable import Wunder

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

	// Helper method for tests
	func mockModelSetup() {
		let context = managedContext

		func insertCarItem(address: String?, longitude: Double, latitude: Double, altitude: Double, engineType: String?, exterior: String?, fuel: Float, interior: String?, name: String?, vin: String?) {
			let obj = NSEntityDescription.insertNewObject(forEntityName: "Car", into: context)

			obj.setValue(address, forKey: "address")
			obj.setValue(longitude, forKey: "longitude")
			obj.setValue(latitude, forKey: "latitude")
			obj.setValue(altitude, forKey: "altitude")
			obj.setValue(engineType, forKey: "engineType")
			obj.setValue(exterior, forKey: "exterior")
			obj.setValue(fuel, forKey: "fuel")
			obj.setValue(interior, forKey: "interior")
			obj.setValue(name, forKey: "name")
			obj.setValue(vin, forKey: "vin")

		}

		insertCarItem(address: "address", longitude: 9.1, latitude: 52.0, altitude: 0, engineType: "CE", exterior: "GOOD", fuel: 100, interior: "GOOD", name: "HH-GO9999", vin: "WME45139999999999")
		insertCarItem(address: "address", longitude: 9.2, latitude: 52.1, altitude: 0, engineType: "CE", exterior: "UNACCEPTABLE", fuel: 100, interior: "GOOD", name: "HH-GOXXXX", vin: "WME4513999999XXXX")

		saveContext()
	}
}
