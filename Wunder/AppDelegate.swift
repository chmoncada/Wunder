//
//  AppDelegate.swift
//  Wunder
//
//  Created by Charles Moncada on 28/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	lazy var coreDataStack: CoreDataStackProtocol = CoreDataStack(modelName: "Wunder")

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		instantiateViewController()

		return true
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		coreDataStack.saveContext()
	}

	func applicationWillTerminate(_ application: UIApplication) {
		coreDataStack.saveContext()
	}
	// MARK: - Private Methods

	private func instantiateViewController() {
		let viewController = WunderViewController.create(coreDataStack: coreDataStack)
		self.window = UIWindow(frame: UIScreen.main.bounds)
		self.window?.rootViewController = viewController
		self.window?.makeKeyAndVisible()
	}

}

