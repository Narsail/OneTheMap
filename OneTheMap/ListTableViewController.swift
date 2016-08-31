//
//  ListTableViewController.swift
//  OneTheMap
//
//  Created by David Moeller on 30/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
	
	private var studentInformationList: [StudentInformation] {
		return SessionManager.shared.studentLocationList
	}

	// MARK: - Controller LifeCycle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		setReloadView()
		
		if SessionManager.shared.reloadNecessary {
			fetchStudentInformationList()
		}
	}

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformationList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationTableViewCell", forIndexPath: indexPath) as! StudentLocationTableViewCell
		
		let studentInformation = studentInformationList[indexPath.row]

        // Configure the cell...
		cell.studentNameLabel.text = "\(studentInformation.firstName) \(studentInformation.lastName)"

        return cell
    }

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		func showURLError() {
			showErrorMessage(withTitle: "No URL provided.", withErrorMessage: "The selected Entry doesn't provide a valid URL.")
		}
		
		let urlString = studentInformationList[indexPath.row].mediaURL
		guard urlString != "", let url = NSURL(string: studentInformationList[indexPath.row].mediaURL) else {
			showURLError()
			return
		}
		if UIApplication.sharedApplication().canOpenURL(url) {
			UIApplication.sharedApplication().openURL(url)
		} else {
			showURLError()
		}
	}
	
	// MARK: - View Settings
	
	func setReloadView() {
		let reloadView = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(ListTableViewController.reload(_:)))
		self.navigationItem.rightBarButtonItem = reloadView
	}
	
	func setLoadingView() {
		let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .Gray)
		let loadingView = UIBarButtonItem(customView: activityIndicator)
		self.navigationItem.rightBarButtonItem = loadingView
		activityIndicator.startAnimating()
	}
	
	// MARK: - Actions
	
	func reload(sender: AnyObject) {
		fetchStudentInformationList()
	}
	
	// MARK: - Data Operations
	
	func fetchStudentInformationList() {
		setLoadingView()
		ParseAPI.shared.fetchStudentInformationList(withCompletionHandler: { list in
			dispatch_async(dispatch_get_main_queue(), {
				SessionManager.shared.set(list)
				self.setReloadView()
				self.tableView.reloadData()
			})
			}, withErrorHandler: { error in
				dispatch_async(dispatch_get_main_queue(), {
					self.showErrorMessage(error)
					self.setReloadView()
				})
		})
	}
	
	// MARK: - Internal Methods
	
	func showErrorMessage(error: ErrorType) {
		// Set the Error Title and Message
		var title = ""
		var message = ""
		switch error {
		default:
			title = "An Error occurred."
			message = "Error: \(error)"
		}
		
		showErrorMessage(withTitle: title, withErrorMessage: message)
	}
	
	func showErrorMessage(withTitle title: String, withErrorMessage errorMessage: String) {
		// Present the Alert View
		let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
		return
	}

}
