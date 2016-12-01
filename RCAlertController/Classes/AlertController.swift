//
//  AlertController.swift
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

//MARK: Alert Action

/// Defines actions to be presented in the alert controller. Initialize it with a name and a command.
///
/// An action will be presented as a button in the alert. You create an alert passing a name and a command
/// block with no parameters or return values. When a button on the alert is pressed the corresponding action
/// will be called. Use the addAction(:) method to add a action you created to the alert.
public class AlertAction {

	public typealias AlertActionCommand = () -> Void
	
	fileprivate var action: AlertActionCommand
	fileprivate var actionName: String
	
	public init(named name: String, withCommand command: @escaping AlertActionCommand) {
		actionName = name
		action = command
	}
	
	fileprivate func execute() {
		// execute the action in the main queue
		let mainQueue = DispatchQueue.main
		mainQueue.async {
			self.action()
		}
	}
}

//MARK: Alert Controller

/// A custom alert controller highly customizable. To see more details see the
/// init(title: message: style:) documentation.
@available(iOS 9.0, *)
public class AlertController: UIViewController, AlertViewDelegate {
	
    //MARK: Private properties
	private var alertView: AlertView!
	private var transitionDelegate = AlertTransitioningDelegate()
	
	// Alert view related properties
	private var alertTitle: String!
	private var message: String?
	private var style: AlertControllerStyle!
	private var actions = [AlertAction]()
	
	//MARK: Initialization
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		fatalError("Storyboard not supported. You should use init(title: message:)")
	}
	
	private func commonInit() {
		self.modalPresentationStyle = .custom
		self.transitioningDelegate = transitionDelegate
	}
	
	//MARK: Life Cycle
	
	override public func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureAlertView()
	}
    
    //MARK: Private Methods
	
	private func setConstraints() {
		alertView.translatesAutoresizingMaskIntoConstraints = false
		var allConstraints = [NSLayoutConstraint]()
		
		// center X
		let centerHorizontallyConstraint = NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
		allConstraints.append(centerHorizontallyConstraint)
		
		// center Y
		let centerVerticallyConstraint = NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
		allConstraints.append(centerVerticallyConstraint)
		
		// fixed width
		let widthConstraint = NSLayoutConstraint(item: alertView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 270)
		allConstraints.append(widthConstraint)
		
		// flexible height
		let heightConstraint = NSLayoutConstraint(item: alertView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: self.view, attribute: .height, multiplier: 0.8, constant: 0)
		allConstraints.append(heightConstraint)
		
		NSLayoutConstraint.activate(allConstraints)
	}
	
    private func configureAlertView() {
		if let appearance = appearance {
			self.alertView = AlertView(appearance: appearance)
		} else {
			self.alertView = AlertView(appearance: AlertAppearance())
		}
		self.alertView.delegate = self
        self.view.addSubview(alertView)
		setConstraints()
		
		//set alert view propeties
		alertView.title = alertTitle
		alertView.message = message
		alertView.style = style
		alertView.actions = actions // must be set after the style
		alertView.customView = customView // must be set after the title and message
		
    }
	
	internal func fireAction(for button: UIButton) {
		
		// find button's action
		guard let index = actions.index(where: { (action) -> Bool  in
			action.actionName == button.title(for: .normal)
		}) else {
			self.dismiss(animated: true, completion: nil)
			return
		}
		
		self.dismiss(animated: true) { [unowned self] in
			self.actions[index].execute()
		}
	}
	
	//MARK: Public API
	
	
	/// A custom view to be desplayed on the alert. 
	///
	/// This view will appear after the title and message, if any exists, and before the buttons.
	/// The width of the view is limited by the width of  the alert. Its height will be preserved
	/// until the alert reaches 80% of the presenting view controller height.
	public var customView: UIView?
	
	/// Defines the appearance of the alert controller.
	/// 
	/// Use it to set a custom appearance to the alert. You can make modifications taking as base
	/// the standard aprearence. Or you can create your own appearance implementing
	/// the AlertAppearanceProtocol.
	public var appearance: AlertAppearanceProtocol?
	
	/// Create an Alert Controller to be presented.
	///
	/// You can set the title and message that will be presented in the alert. Additionally you can set the style
	/// of the alert that will be presented. There are two styles: 'standard' and 'actionAlert'.
	///
	/// To costumize the appearance of the alert use the appearance property. You can create your own
	/// appearance using the AlertAppearance struct and set it to the alert.
	///
	/// To add actions create an AlertAction and use the addAction(:) method to add them.
	///
	/// - parameter title:   A String that will be presented as the alert title.
	/// - parameter message: An optional String message to be displayed on the alert.
	/// - parameter style:   The alert layout style. You can choose between 'standard' and 'actionAlert'.
	/// See more in AlertControllerStyle.
	///
	/// - returns: The AlertController to be presented.
	public init(title: String, message: String?, style: AlertControllerStyle = .standard) {
		super.init(nibName: nil, bundle: nil)
		commonInit()
		self.alertTitle = title
		self.message = message
		self.style = style
	}
	
	
	/// Add an alert action to the alert view.
	///
	/// This action will be represented with a button on the alert view with the name of the action.
	/// The order of the buttons will be given by the order the actions
	/// are added. If there any other actions already in the alert they will be presented after those.
	/// 
	/// - note: In the 'standard' style the number of actions is limited to two. Any actions added after
	/// this limit has been reached will be discarted.
	///
	/// - parameter action: An AlertAction that will be added to the alert view.
	public func addAction(action: AlertAction) {
		if style == .standard {
			guard actions.count < 2 else { return }
			actions.append(action)
		} else {
			actions.append(action)
		}
	}
	
	
	/// Adds to the alert view the list of actions passed.
	///
	/// Those actions will be presented in the order
	/// they appear in the array as buttons with title equal to the name of the actions. If there any other
	/// actions already in the alert they will be presented after those.
	///
	/// - note: In the 'standard' style the number of actions is limited to two. Any actions added after
	/// this limit has been reached will be discarted.
	///
	/// - parameter actions: An array of actions to be added to the alert view
	public func addActions(actions: [AlertAction]) {
		for action in actions {
			addAction(action: action)
		}
	}
}

//MARK: Alert View Delegate
fileprivate protocol AlertViewDelegate: class {
	func fireAction(for button: UIButton)
}

//MARK: Alert View
@available(iOS 9.0, *)
fileprivate class AlertView: UIView {
	
	// MARK: Private properties
	
	/// The title label from the alert view
	private var titleLabel =  UILabel()
	
	/// The main text view from the alert view
	private var textLabel: UILabel?
	
	/// The action buttons from the alert view. Each button will be linked to an action added by the caller.
	private var actionButtons = [UIButton]()
	
	/// A container view that will contain all the labels and textViews of the alert.
	private var textConteinerView = UIStackView(frame: CGRect.zero)
	
	/// A container view for a custom view given by the user
	private var customContainerView = UIStackView(frame: CGRect.zero)
	
	/// A container view that will contain all the buttons of the alert.
	private var buttonsConteinerView = UIStackView(frame: CGRect.zero)
	
	//MARK: Fileprivate properties
	
	/// A reference to the view controller
	fileprivate weak var delegate: AlertViewDelegate!
	
	fileprivate var title: String! {
		didSet{
			titleLabel.text = title
			titleLabel.textColor = appearance.titleColor
			titleLabel.font = appearance.titleFont
		}
	}
	
	fileprivate var message: String? {
		didSet {
			guard let text = message else { return }
			textLabel = UILabel(frame: .zero)
			textLabel!.translatesAutoresizingMaskIntoConstraints = false
			textLabel!.text = text
			textLabel!.font = appearance.messageFont
			textLabel!.textColor = appearance.messageColor
			textLabel!.numberOfLines = 0
			textLabel!.textAlignment = .center
			textConteinerView.addArrangedSubview(textLabel!)
		}
	}
	
	fileprivate var actions: [AlertAction]? {
		didSet {
			if let actions = actions, actions.count > 0 {
				// if there are any actions to be displayed add them
				for action in actions {
					addButton(for: action)
				}
			} else {
				// if not add the default button that does nothig
				let action = AlertAction(named: "OK", withCommand: { })
				addButton(for: action)
			}
		}
	}
	
	fileprivate var style: AlertControllerStyle = .standard {
		didSet {
			// change the buttons layout distribution acording to the sytle setted
			switch style {
			case .standard:
				buttonsConteinerView.axis = .horizontal
			case .actionAlert:
				buttonsConteinerView.axis = .vertical
			}
		}
	}
	
	fileprivate var customView: UIView? {
		willSet {
			guard let view = newValue else { return }
			guard customView == nil else { return }
			view.translatesAutoresizingMaskIntoConstraints = false
			self.customContainerView.addArrangedSubview(view)
			let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: view.frame.height)
			// constraint with low priority so that if the view is to big
			// it's shortened keeping the other elements aspect
			heightConstraint.priority = 250
			NSLayoutConstraint.activate([heightConstraint])
		}
	}
	
	fileprivate var appearance: AlertAppearanceProtocol!
	
	// MARK: Initialization
	
	fileprivate init(appearance: AlertAppearanceProtocol) {
		super.init(frame: CGRect.zero)
		self.appearance = appearance
		commonInit()
	}
	
	fileprivate required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		fatalError("init(coder:) has not been implemented")
	}
	
	private func commonInit() {
		addContainerViews()
		
		// Configure view appearance
		self.backgroundColor = appearance.viewBackgroundColor
		self.layer.cornerRadius = appearance.viewCornerRadius
		self.clipsToBounds = true

	}
	
	// MARK: Private methods
	
	/// Set the constraints of the container views.
	private func configureContainerViewsConstraints() {
		
		textConteinerView.translatesAutoresizingMaskIntoConstraints = false
		buttonsConteinerView.translatesAutoresizingMaskIntoConstraints = false
		customContainerView.translatesAutoresizingMaskIntoConstraints = false
		
		// views dictionary that holds string representations of views to resolve inside the format string. The string keys inside the views dictionary must match the view strings inside the format string.
		let views = ["textConteinerView": textConteinerView,
		             "buttonsConteinerView": buttonsConteinerView,
		             "customContainerView": customContainerView]
		
		var allConstraints = [NSLayoutConstraint]()
		
		// Each container view is spaced by 8 points.
		let bottomSpace = appearance.spaceToBottomMargin
		let containersVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[textConteinerView]-8-[customContainerView]-8-[buttonsConteinerView]-\(bottomSpace)-|", options: [], metrics: nil, views: views)
		allConstraints += containersVerticalConstraints
		
		// Both containers has standard horizontal space to superview
		let buttonsHorizSpace = appearance.buttonsSpaceToHorizontalMargins
		let textHorizSpace = appearance.textSpaceToHorizontalMargins
		let customHorizSpace = appearance.customViewSpaceToHorizontalMargins
		let horizontalTextContainerConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(textHorizSpace)-[textConteinerView]-\(textHorizSpace)-|", options: [], metrics: nil, views: views)
		let hozizontalButtonsContainerConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(buttonsHorizSpace)-[buttonsConteinerView]-\(buttonsHorizSpace)-|", options: [], metrics: nil, views: views)
		let horizontalCustomContainerConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(customHorizSpace)-[customContainerView]-\(customHorizSpace)-|", options: [], metrics: nil, views: views)
		allConstraints += horizontalTextContainerConstraints + hozizontalButtonsContainerConstraints + horizontalCustomContainerConstraints
		
		NSLayoutConstraint.activate(allConstraints)
	}
	
	/// Adds the container view and call the configurations methods to each one
	private func addContainerViews() {
		// Add containers
		self.addSubview(textConteinerView)
		self.addSubview(customContainerView)
		self.addSubview(buttonsConteinerView)
		configureContainerViewsConstraints()
		configureTextContainerView()
		configureButtonsContainerView()
	}
	
	// standard configuration
	private func configureTextContainerView() {
		// set stack view axis to vertical
		textConteinerView.axis = .vertical
		textConteinerView.spacing = 8.0
		
		// add title label
		titleLabel.textAlignment = .center
		titleLabel.numberOfLines = 0
		titleLabel.font = appearance.titleFont
		titleLabel.textColor = appearance.titleColor
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		textConteinerView.addArrangedSubview(titleLabel)
	}
	
	// standard configuration
	private func configureButtonsContainerView() {
		// configure the stack view distribution constraints
		buttonsConteinerView.axis = .horizontal
		buttonsConteinerView.spacing = appearance.buttonsSpacing
		buttonsConteinerView.distribution = .fillEqually
	}
	
	@objc private func actionButtonTapped(sender: UIButton) {
		delegate.fireAction(for: sender)
	}
	
	private func addButton(for action: AlertAction) {
		let actionButton = UIButton()
		actionButton.translatesAutoresizingMaskIntoConstraints = false
		actionButton.setTitle(action.actionName, for: .normal)
		actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
		actionButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
		
		// set appearance
		actionButton.backgroundColor = appearance.buttonsBackgroundColor
		actionButton.setTitleColor(appearance.buttonsTextColor, for: .normal)
		actionButton.titleLabel?.font = appearance.buttonsFont
		actionButton.layer.cornerRadius = appearance.buttonsCornerRadius
		actionButton.titleLabel?.adjustsFontSizeToFitWidth = true

		buttonsConteinerView.addArrangedSubview(actionButton)
	}
}	
