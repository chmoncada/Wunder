//
//  UIViewControllerUtilTests.swift
//  WunderTests
//
//  Created by Charles Moncada on 07/10/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import XCTest
import UIKit

@testable import Wunder

class UIViewControllerUtilTests: XCTestCase {

	func testShowErrorMethod() {

		let vc = UIViewController()
		let alert = vc.showError("test", message: "This is a test")

		XCTAssertEqual(alert.title, "test")
		XCTAssertEqual(alert.message, "This is a test")

	}
}
