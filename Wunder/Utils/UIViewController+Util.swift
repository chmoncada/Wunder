//
//  UIViewController+Util.swift
//  Wunder
//
//  Created by Charles Moncada on 29/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//
import UIKit

extension UIViewController {
	@discardableResult func showError(_ title: String, message: String) -> UIAlertController {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(OKAction)
		present(alertController, animated: true, completion: nil)

		return alertController
	}
}
