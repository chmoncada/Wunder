//
//  NSError+Util.swift
//  Wunder
//
//  Created by Charles Moncada on 29/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import Foundation

extension NSError {
	static func createError(_ code: Int, description: String) -> NSError {
		return NSError(domain: "com.wunder.test",
					   code: 400,
					   userInfo: [
						"NSLocalizedDescription" : description
			])
	}
}
