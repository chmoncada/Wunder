//
//  CarManager.swift
//  Wunder
//
//  Created by Charles Moncada on 02/10/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import Foundation
import CoreData

enum Result {
	case success([Car])
	case error(NSError?)
}

// Json Codable structure
struct JSONStructure: Codable {
	let placemarks: [Car]
}

typealias FetchCarsCompletionBlock = (Result) -> Void

protocol CarManagerProtocol: class {
	func fetchCarData(_ completionBlock: @escaping (Result) -> Void)
}

class CarManager: CarManagerProtocol {

	//private static let entityName = "Car"
	private let coreDataStack: CoreDataStackProtocol
	private let session: URLSession
	private var fetchCarsCompletionBlock: FetchCarsCompletionBlock?

	init(coreDataStack: CoreDataStackProtocol, session: URLSession = URLSession.shared) {
		self.coreDataStack = coreDataStack
		self.session = session
	}

	func fetchCarData(_ completionBlock: @escaping FetchCarsCompletionBlock) {
		fetchCarsCompletionBlock = completionBlock
		fetchData()
	}
}

extension CarManager {

	private func fetchData() {

		let headers = [ "Cache-Control": "no-cache" ]
		let request = NSMutableURLRequest(url: NSURL(string: "https://s3-us-west-2.amazonaws.com/wunderbucket/locations.json")! as URL,
										  cachePolicy: .useProtocolCachePolicy,
										  timeoutInterval: 10.0)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = headers

		let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
			guard let strongSelf = self else { return }

			guard let jsonData = data, error == nil else {
				DispatchQueue.main.async {
					strongSelf.fetchCarsCompletionBlock?(.error(error as NSError?))
				}
				return
			}

			if strongSelf.parse(jsonData) {
				guard let cars = strongSelf.fetchFromStorage() else { fatalError() }
				DispatchQueue.main.async {
					strongSelf.fetchCarsCompletionBlock?(.success(cars))
				}
			} else {
				DispatchQueue.main.async {
					strongSelf.fetchCarsCompletionBlock?(.error(NSError.createError(0, description: "JSON parsing error")))
				}
			}
		})

		dataTask.resume()
	}

	private func parse(_ jsonData: Data) -> Bool {
		do {
			guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
				fatalError("Failed to retrieve managed object context")
			}

			// Clear storage and save managed object instances
			clearStorage()

			// Parse JSON data
			let managedObjectContext = coreDataStack.managedContext
			let decoder = JSONDecoder()
			decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext // inject managedObjectContext to decode
			_ = try decoder.decode(JSONStructure.self, from: jsonData)
			try managedObjectContext.save()
			return true
		} catch let error {
			print(error)
			return false
		}
	}

	private func fetchFromStorage() -> [Car]? {
		let managedObjectContext = coreDataStack.managedContext
		let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
		do {
			let users = try managedObjectContext.fetch(fetchRequest)
			return users
		} catch let error {
			print(error)
			return nil
		}
	}

	private func clearStorage() {
		let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
		let objs = try! coreDataStack.managedContext.fetch(fetchRequest)
		for case let obj as NSManagedObject in objs {
			coreDataStack.managedContext.delete(obj)
		}

		coreDataStack.saveContext()
	}
}
