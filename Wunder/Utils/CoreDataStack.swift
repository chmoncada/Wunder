//
//  CoreDataStack.swift
//  Wunder
//
//  Created by Charles Moncada on 02/10/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol: class {
	var storeContainer: NSPersistentContainer { get set }
	var managedContext: NSManagedObjectContext { get }

	func saveContext()
}

class CoreDataStack: CoreDataStackProtocol {

	private let modelName: String

	lazy var managedContext: NSManagedObjectContext = {
		return self.storeContainer.viewContext
	}()

	init(modelName: String) {
		self.modelName = modelName
	}

	lazy var storeContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: self.modelName)
		container.loadPersistentStores { storeDescription, error in
			if let error = error as NSError? {
				print("Unresolved  error \(error), \(error.userInfo)")
			}
		}
		return container
	}()

	func saveContext() {
		guard managedContext.hasChanges else { return }

		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Unresolved error \(error), \(error.userInfo)")
		}
	}

}
