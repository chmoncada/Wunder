//
//  VerticalProgressBarView.swift
//  Wunder
//
//  Created by Charles Moncada on 30/09/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit

class VerticalProgressBarView: UIView {
	// MARK: - Private Variables
	private var backgroundImage : UIView!
	private var progressView : UIImageView!

	// MARK: - Overriden Methods
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.initBar()
	}

	override var intrinsicContentSize: CGSize {
		return CGSize(width: frame.size.width, height: frame.size.height)
	}

	func initBar() {
		// make the container with rounded corners and clear background.
//		self.layer.cornerRadius = frame.size.width / 2
//		self.layer.masksToBounds = true
//		self.backgroundColor = UIColor.clear

		let backgroundRect = CGRect(x: 0.0, y: 0.0, width: Double(frame.size.width), height: Double(frame.size.height))
		backgroundImage = UIView(frame: backgroundRect)
		backgroundImage.clipsToBounds = true
		backgroundImage.layer.borderWidth = 1
		backgroundImage.layer.borderColor = UIColor.black.cgColor
		backgroundImage.backgroundColor = .white
		addSubview(backgroundImage)

		//level of progress
		let progressRect = CGRect(x: 0.0, y: Double(frame.size.height), width: Double(frame.size.width), height: 0.0)
		progressView = UIImageView(frame: progressRect)
//		progressView.layer.cornerRadius = frame.size.width / 2
//		progressView.layer.masksToBounds = true
		progressView.backgroundColor = .blue
		addSubview(progressView)
	}

	func setProgressValue(currentValue : CGFloat , threshold  : CGFloat = 100.0) {
		let yOffset = ((threshold - currentValue) / threshold) * frame.size.height / 1

		self.progressView.frame.size.height = self.frame.size.height - yOffset
		self.progressView.frame.origin.y = yOffset

	}

}
