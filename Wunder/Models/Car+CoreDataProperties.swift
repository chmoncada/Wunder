//
//  Car+CoreDataProperties.swift
//  Wunder
//
//  Created by Charles Moncada on 29/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var address: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var altitude: Double
    @NSManaged public var engineType: String?
    @NSManaged public var exterior: String?
    @NSManaged public var fuel: Float
    @NSManaged public var interior: String?
    @NSManaged public var name: String?
    @NSManaged public var vin: String?

}
