//
//  WunderPresenter.swift
//  Wunder
//
//  Created by Charles Moncada on 29/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import Foundation
import CoreData

// MARK: - PresenterProtocol

protocol WunderPresenterProtocol {
	var items: [Car] { get }
	var itemCount: Int { get }

	func item(at index: Int) -> Car
	func viewDidLoad()
}

extension WunderPresenterProtocol {
	var items: [Car] {
		return items
	}

	var itemCount: Int {
		return items.count
	}

	func item(at index: Int) -> Car {
		guard index >= 0 && index < itemCount else { fatalError() }
		return items[index]
	}
}

// MARK: - Presenter

class WunderPresenter: WunderPresenterProtocol {

	private weak var view: WunderViewControllerProtocol?
	private let coreDataStack: CoreDataStackProtocol
	private var carManager: CarManagerProtocol

	var items: [Car] = [] {
		didSet {
			view?.reloadData()
		}
	}

	init(view: WunderViewControllerProtocol, coreDataStack: CoreDataStackProtocol) {
		self.coreDataStack = coreDataStack
		self.view = view
		carManager = CarManager(coreDataStack: coreDataStack)
	}

	func viewDidLoad() {
		fetchCarData()
	}

	private func fetchCarData() {
		carManager.fetchCarData { [weak self] result in
			switch result {
			case .success(let items):
				self?.items = items
			case .error(let error):
				self?.view?.showError(error)
			}
		}
	}
}
