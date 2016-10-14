//
//  TotallyCustomAppearence.swift
//  RCAlertController
//
//  Created by Rodrigo Carvalho da Silva on 10/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import RCAlertController

struct TotallyCustomAppearence: AlertAppearanceProtocol {
	var buttonsFont = UIFont(name: "Futura", size: 17)!
	var buttonsSpacing: CGFloat = 1.0
	var buttonsTextColor = UIColor.white
	var buttonsCornerRadius: CGFloat = 0
	var buttonsBackgroundColor = UIColor.green.withAlphaComponent(0.7)
	var buttonsSpaceToHorizontalMargins: Float = 1.0
	
	var titleFont = UIFont(name: "Futura", size: 20)!
	var titleColor = UIColor.white
	var messageFont = UIFont(name: "Futura", size: 17)!
	var messageColor = UIColor.white
	var textSpaceToHorizontalMargins: Float = 8.0
	
	var viewCornerRadius: CGFloat = 4.0
	var viewBackgroundColor = UIColor.black
	
	var spaceToBottomMargin: Float = 8.0
	var customViewSpaceToHorizontalMargins: Float = 8.0
	
}
