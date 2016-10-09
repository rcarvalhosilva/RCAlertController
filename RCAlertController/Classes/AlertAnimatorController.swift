//
//  AlertAnimatorController.swift
//  RCAlertController
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

class AlertAnimatorController: NSObject, UIViewControllerAnimatedTransitioning {
	
	//MARK: Nested Types
	
	enum TransitionType: Int {
		case presentation
		case dismissal
	}
	
	//MARK: Private properties
	
	private var transition: TransitionType
	
	//MARK: Initialization
	
	init(transition: TransitionType) {
		self.transition = transition
		super.init()
	}
	
	//MARK: Methods
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.25
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		
		// Getting the animation relevant objects.
		guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
		guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
		let toView = transitionContext.view(forKey: .to)
		let fromView = transitionContext.view(forKey: .from)

		let containerView = transitionContext.containerView
		let containerFrame = containerView.frame
		var toViewStartFrame = transitionContext.initialFrame(for: toViewController)
		let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
		var fromViewFinalFrame = transitionContext.finalFrame(for: fromViewController)
		
		// set up animation parameters
		if transition == .presentation {
			// Modify the frame of the presented view so that it starts
			// ofscreen on the top of the screen with the same size as the container view
			toViewStartFrame = CGRect(x: 0, y: -containerFrame.height, width: containerFrame.width, height: containerFrame.height)
			
			// add the to view do the container view setting its initial position
			containerView.addSubview(toView!)
			toView!.frame = toViewStartFrame
			
		} else {
			// Modify the frame of the dismissed view so it ends
			// of the screen exiting throug the bottom
			fromViewFinalFrame = CGRect(x: 0, y: containerFrame.height, width: containerFrame.width, height: containerFrame.height)
		}
		
		// Animate using the animator's own duration value.
		UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
			
			if self.transition == .presentation {
				// Move the presented view into position.
				toView?.frame = toViewFinalFrame
			} else {
				// zoom out the dismissed view.
				fromView?.frame = fromViewFinalFrame
			}
			
			}) { (finished) in
				
				let success = !transitionContext.transitionWasCancelled
				
				// After a failed presentation or successful dismissal, remove the toView.
				if (!success && self.transition == .presentation) || (self.transition == .dismissal && success) {
					toView?.removeFromSuperview()
				}
				
				// Notify UIKit that the transition has finished
				transitionContext.completeTransition(success)
		}
	
	}
}
