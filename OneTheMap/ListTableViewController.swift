//
//  ListTableViewController.swift
//  OneTheMap
//
//  Created by David Moeller on 30/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

	// MARK: - Controller LifeCycle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if SessionManager.shared.reloadNecessary {
			fetchStudentInformationList()
		}
	}

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SessionManager.shared.studentLocationList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationTableViewCell", forIndexPath: indexPath) as! StudentLocationTableViewCell
		
		let studentInformation = SessionManager.shared.studentLocationList[indexPath.row]

        // Configure the cell...
		cell.studentNameLabel.text = "\(studentInformation.firstName) \(studentInformation.lastName)"

        return cell
    }

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		func showURLError() {
			showErrorMessage(withTitle: "No URL provided.", withErrorMessage: "The selected Entry doesn't provide a valid URL.", viewController: self)
		}
		
		let urlString = SessionManager.shared.studentLocationList[indexPath.row].mediaURL
		guard urlString != "", let url = NSURL(string: SessionManager.shared.studentLocationList[indexPath.row].mediaURL) else {
			showURLError()
			return
		}
		
		if UIApplication.sharedApplication().canOpenURL(url) {
			UIApplication.sharedApplication().openURL(url)
		} else {
			showURLError()
		}
	}
	
	// MARK: - Actions
	
	@IBAction func setPin(sender: AnyObject) {
		if let _ = SessionManager.shared.ownInformation {
			let alert = UIAlertController(title: "Location exists already.", message: "You posted a Location already. Do you want to override it?", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
			alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
				self.performSegueWithIdentifier("showInputSegue", sender: self)
			}))
			self.presentViewController(alert, animated: true, completion: nil)
		} else {
			self.performSegueWithIdentifier("showInputSegue", sender: self)
		}
	}
	
	@IBAction func logout(sender: AnyObject) {
		let alert = UIAlertController(title: "Log out.", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
		alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
			// Remove Session
			SessionManager.shared.sessionID = nil
			self.dismissViewControllerAnimated(true, completion: nil)
		}))
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	// MARK: - Data Operations
	
	func fetchStudentInformationList() {
		ParseAPI.shared.fetchStudentInformationList(withCompletionHandler: { list in
			SessionManager.shared.studentLocationList = list
			dispatch_async(dispatch_get_main_queue(), {
				self.tableView.reloadData()
			})
		}, withErrorHandler: { error in
			dispatch_async(dispatch_get_main_queue(), {
				showError(error, viewController: self)
			})
		})
	}

}
