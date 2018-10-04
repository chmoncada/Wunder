//
//  WunderViewController+UITable.swift
//  Wunder
//
//  Created by Charles Moncada on 30/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit

extension WunderViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.itemCount ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CarInfoCardCell", for: indexPath) as! CarInfoCardCell
		let item = presenter.item(at: indexPath.row)

		cell.config(with: item)
		return cell
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 120
	}
}
