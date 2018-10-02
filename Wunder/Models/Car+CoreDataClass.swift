//
//  Car+CoreDataClass.swift
//  Wunder
//
//  Created by Charles Moncada on 29/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

@objc(Car)
public class Car: NSManagedObject, Codable {

	enum CodingKeys: String, CodingKey {
		case address
		case coordinates
		case engineType
		case exterior
		case fuel
		case interior
		case name
		case vin
	}

	// MARK: - Decodable
	required convenience public init(from decoder: Decoder) throws {
		guard
			let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
			let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
			let entity = NSEntityDescription.entity(forEntityName: "Car", in: managedObjectContext)
		else { fatalError("Failed to decode Car") }

		self.init(entity: entity, insertInto: managedObjectContext)

		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.address = try container.decodeIfPresent(String.self, forKey: .address)
		self.engineType = try container.decodeIfPresent(String.self, forKey: .engineType)
		self.exterior = try container.decodeIfPresent(String.self, forKey: .exterior)
		self.fuel = try container.decodeIfPresent(Float.self, forKey: .fuel) ?? 0
		self.interior = try container.decodeIfPresent(String.self, forKey: .interior)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.vin = try container.decodeIfPresent(String.self, forKey: .vin)

		let coordinates = try container.decodeIfPresent(Array<Double>.self, forKey: .coordinates)
		self.longitude = coordinates?[0] ?? 0
		self.latitude = coordinates?[1] ?? 0
		self.altitude = coordinates?[2] ?? 0

	}

	// MARK: - Encodable
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(address, forKey: .address)
		try container.encode(engineType, forKey: .engineType)
		try container.encode(exterior, forKey: .exterior)
		try container.encode(fuel, forKey: .fuel)
		try container.encode(interior, forKey: .interior)
		try container.encode(name, forKey: .name)
		try container.encode(vin, forKey: .vin)
		try container.encode([longitude, latitude, altitude], forKey: .coordinates)
	}
}
