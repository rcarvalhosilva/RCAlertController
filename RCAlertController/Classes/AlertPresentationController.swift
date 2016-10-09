//
//  AlertPresentationController.swift
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

import UIKit

internal class AlertPresentationController: UIPresentationController {
	
	private var dimmingView: UIView!
	
	override var frameOfPresentedViewInContainerView: CGRect {
		return self.containerView!.bounds
	}
	
	//MARK: Initialization
	
	override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
		
		// create and set dimming view appearance
		self.dimmingView = UIView()
		self.dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.6)
		self.dimmingView.alpha = 0.0
		
	}
	
	//MARK: Presentation
	
	override func presentationTransitionWillBegin() {
		let containerView = self.containerView!
		let presentedViewController = self.presentedViewController
		
		// set the dimming view to the same size as the container's bounds.
		// and transparent as well
		self.dimmingView.frame = containerView.bounds
		self.dimmingView.alpha = 0.0
		
		// insert dimming view initially above the presenting view controller's view
		containerView.insertSubview(dimmingView, aboveSubview: presentingViewController.view)
		
		// add animation fade in the dimming view
		if let presentedCoordinator = presentedViewController.transitionCoordinator {
			
			presentedCoordinator.animate(alongsideTransition: { [unowned self] (context) in
			
				// fade in dimming view
				self.dimmingView.alpha = 1.0
				
				}, completion: nil)
		} else {
			self.dimmingView.alpha = 1.0
		}
	}
	
	
	override func presentationTransitionDidEnd(_ completed: Bool) {
		// If the presentation was canceled, remove the dimming view.
		if !completed {
			self.dimmingView.removeFromSuperview()
		}
	}
	
	//MARK: Dismissal
	
	override func dismissalTransitionWillBegin() {
		// fade dimming view back out
		if let presentedCoordinator = presentedViewController.transitionCoordinator {
			
			presentedCoordinator.animate(alongsideTransition: { [unowned self] (context) in
				
				// fade in dimming view
				self.dimmingView.alpha = 0.0
				
				}, completion: nil)
		} else {
			self.dimmingView.alpha = 0.0
		}
	}
	
	override func dismissalTransitionDidEnd(_ completed: Bool) {
		// If the dismissal was successful, remove the dimming view.
		if completed {
			self.dimmingView.removeFromSuperview()
		}
	}
	
	//MARK: Rotation
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		
		coordinator.animate(alongsideTransition: { [unowned self] (context) in
			
			// set the new size of the diming view corresponding to the rotation
			self.dimmingView.frame.size = size
			
		}, completion: nil)

	}
}
