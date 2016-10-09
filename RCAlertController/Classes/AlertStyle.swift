//
//  AlertStyle.swift
//  AlertController
//
//  Copyright (c) 2016 Rodrigo Silva
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy of
//	this software and associated documentation files (the "Software"), to deal in the
//	Software without restriction, including without limitation the rights to use,
//	copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
//	Software, and to permit persons to whom the Software is furnished to do so,
//	subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
//	AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import UIKit



/// Defines the alert presentation style.
///
/// - **standard**:	In this style the alert is presented like a dialog. With **at most two(2)** action buttons
/// arranged side-by-side. If you add more than two actions only the first two will be displayed.
///
///
/// - **actionAlert**: In this style the alert is presented like an action dialog. In this style the number of
/// actions is unlimited and they are arranged vertically. Even though the number of actions is unlimited
/// if you add too many action the content of your alert might get hidden by lack of space.
public enum AlertControllerStyle: Int {
	case standard
	case actionAlert
}

//enum ActionStyle: Int {
//	case normal
//	case destructive
//}


/// This protocol defines all the properties you can customize in the alert controller.
///
/// You can use this protocol to create your own custom appearance from the scratch and easily use it
/// throughout your code. The standard AlertAppearance struct implements this protocol. If you don't
/// want to create a whole new appearance you can build a custom appearance upon the standard 
/// AlertAppearance struct.
public protocol AlertAppearanceProtocol {
	var buttonsFont: UIFont { get set }
	var buttonsTextColor: UIColor { get set }
	var buttonsBackgroundColor: UIColor { get set }
	var buttonsCornerRadius: CGFloat { get set }
	var buttonsSpacing: CGFloat { get set }
	var messageColor: UIColor { get set }
	var messageFont: UIFont { get set }
	var titleColor: UIColor { get set }
	var titleFont: UIFont { get set }
	var viewBackgroundColor: UIColor { get set }
	var viewCornerRadius: CGFloat  { get set }
	
	// constraint customization
	var textSpaceToHorizontalMargins: Float { get set }
	var customViewSpaceToHorizontalMargins: Float { get set }
	var buttonsSpaceToHorizontalMargins: Float { get set }
	var spaceToBottomMargin: Float { get set }
}

/// Define a standard appearence to the alert controller.
///
/// This struct implements the AlertAppearanceProtocol creating a standard appearence to the alert.
/// You can instantiate it and create a different appearence based on this one by changing it's properties.
/// Or you can instantiate a new one with new values using the convenience init.
public struct AlertAppearance: AlertAppearanceProtocol {
	
	public var buttonsFont: UIFont = UIFont.boldSystemFont(ofSize: 20)
	public var buttonsTextColor: UIColor = UIColor.white
	public var buttonsBackgroundColor: UIColor = UIColor.lightGray
	public var buttonsCornerRadius: CGFloat = 5
	public var buttonsSpacing: CGFloat = 8
	public var messageColor: UIColor = UIColor.black
	public var messageFont: UIFont = UIFont.systemFont(ofSize: 15)
	public var titleColor: UIColor = UIColor.black
	public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 20)
	public var viewBackgroundColor: UIColor = UIColor.white
	public var viewCornerRadius: CGFloat = 5
	
	// constraint customization
	public var buttonsSpaceToHorizontalMargins: Float = 8
	public var textSpaceToHorizontalMargins: Float = 8
	public var customViewSpaceToHorizontalMargins: Float = 8
	public var spaceToBottomMargin: Float = 8
	
	public init() { }
	
	public init(buttonsFont: UIFont = UIFont.boldSystemFont(ofSize: 20),
	 buttonsTextColor: UIColor = UIColor.white,
	 buttonsBackgroundColor: UIColor = UIColor.lightGray,
	 buttonsCornerRadius: CGFloat = 5,
	 buttonsSpacing: CGFloat = 8,
	 messageColor: UIColor = UIColor.black,
	 messageFont: UIFont = UIFont.systemFont(ofSize: 15),
	 titleColor: UIColor = UIColor.black,
	 titleFont: UIFont = UIFont.boldSystemFont(ofSize: 20),
	 viewBackgroundColor: UIColor = UIColor.white,
	 viewCornerRadius: CGFloat = 5,
	 buttonsSpaceToHorizontalMargins: Float = 8,
	 spaceToBottomMargin: Float = 8,
	 textSpaceToHorizontalMargins: Float = 8,
	 customViewSpaceToHorizontalMargins: Float = 8) {
		
		self.viewBackgroundColor = viewBackgroundColor
		self.viewCornerRadius = viewCornerRadius
		self.buttonsBackgroundColor = buttonsBackgroundColor
		self.buttonsTextColor = buttonsTextColor
		self.buttonsFont = buttonsFont
		self.buttonsCornerRadius = buttonsCornerRadius
		self.buttonsSpacing = buttonsSpacing
		self.messageColor = messageColor
		self.messageFont = messageFont
		self.titleFont = titleFont
		self.titleColor = titleColor
		self.buttonsSpaceToHorizontalMargins = buttonsSpaceToHorizontalMargins
		self.spaceToBottomMargin = spaceToBottomMargin
		self.textSpaceToHorizontalMargins = textSpaceToHorizontalMargins
		self.customViewSpaceToHorizontalMargins = customViewSpaceToHorizontalMargins
	}
}
