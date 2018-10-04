//
//  CarInfoCardCell.swift
//  Wunder
//
//  Created by Charles Moncada on 30/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit

class CarInfoCardCell: UITableViewCell {

	@IBOutlet weak var carNameLabel: UILabel!
	@IBOutlet weak var carVINLabel: UILabel!
	@IBOutlet weak var exteriorAppearanceImage: UIImageView!
	@IBOutlet weak var interiorAppearanceImage: UIImageView!
	@IBOutlet weak var fuelIndicatorView: VerticalProgressBarView!
	@IBOutlet weak var fuelIndicatorLabel: UILabel!

	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func prepareForReuse() {
		carNameLabel.text = nil
		carVINLabel.text = nil

		exteriorAppearanceImage.image = nil
		interiorAppearanceImage.image = nil

		fuelIndicatorView.setProgressValue(currentValue: 0)
		fuelIndicatorLabel.text = nil
	}

	func config(with car: Car) {
		carNameLabel.text = car.name
		carVINLabel.text = car.vin

		exteriorAppearanceImage.image = UIImage.appearanceImage(with: car.exterior)
		interiorAppearanceImage.image = UIImage.appearanceImage(with: car.interior)

		fuelIndicatorView.setProgressValue(currentValue: CGFloat(car.fuel))
		fuelIndicatorLabel.text = "\(Int(car.fuel))%"
	}

}

private extension UIImage {
	static func appearanceImage(with value: String?) -> UIImage? {
		switch value {
		case "GOOD":
			return #imageLiteral(resourceName: "green")
		case "UNACCEPTABLE":
			return #imageLiteral(resourceName: "red")
		default:
			return nil
		}
	}
}
