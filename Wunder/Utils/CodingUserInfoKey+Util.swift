//
//  CodingUserInfoKey+Util.swift
//  Wunder
//
//  Created by Charles Moncada on 29/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import Foundation

public extension CodingUserInfoKey {
	// Helper property to retrieve the Core Data managed object context
	static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
