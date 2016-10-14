//
//  ExampleController.swift
//  RCAlertController
//
//  Created by Rodrigo Carvalho da Silva on 09/10/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import MapKit
import RCAlertController

class ExampleController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let action1 = AlertAction(named: "Nice!") { 
			print("You just tapped action 1")
		}
		let action2 = AlertAction(named: "Wow!") { 
			print("You just tapped action 2")
		}
		let action3 = AlertAction(named: "OMG!") {
			print("You just tapped action 3")
		}
		switch indexPath.row {
		case 0:
			let alert = AlertController(title: "Look at that!", message: "This is a standard alert!")
			self.present(alert, animated: true, completion: nil)
		case 1:
			let alert = AlertController(title: "Look at that!", message: "This is a action alert!", style: .actionAlert)
			alert.addActions([action1, action2])
			self.present(alert, animated: true, completion: nil)
		case 2:
			let alert = AlertController(title: "This song is playing on another device", message: nil, style: .actionAlert)
			alert.appearance = TotallyCustomAppearence()
			alert.addActions([action2, action3])
			self.present(alert, animated: true, completion: nil)
		case 3:
			let alert = AlertController(title: "Parking Spot", message: "Your car is parked on the place bellow")
			
			let map = MKMapView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
			map.showsUserLocation = true
			map.userTrackingMode = .follow
			
			var appearence = AlertAppearance()
			appearence.buttonsBackgroundColor = UIColor.cyan
			appearence.buttonsTextColor = UIColor.black
			
			alert.appearance = appearence
			alert.customView = map
			alert.addAction(action: action1)
			alert.addAction(action: action2)
			self.present(alert, animated: true, completion: nil)
		default:
			break
		}
	}
}
