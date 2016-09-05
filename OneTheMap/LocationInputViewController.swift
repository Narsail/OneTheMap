//
//  LocationInputViewController.swift
//  OneTheMap
//
//  Created by David Moeller on 30/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationInputViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var locationTextField: UITextField! {
		didSet {
			configureTextField(locationTextField)
		}
	}
	
	@IBOutlet weak var urlTextField: UITextField! {
		didSet {
			configureTextField(urlTextField)
		}
	}
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var submitButton: UIButton! {
		didSet {
			submitButton.enabled = false
		}
	}
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
		didSet {
			activityIndicator.hidden = true
		}
	}
	
	var location: CLLocation?
	
	func configureTextField(textField: UITextField) {
		// Set Delegate
		textField.delegate = self
		
		// Draw bottom border
		// With little help of Stack Overflow: http://stackoverflow.com/questions/26800963/uitextfield-border-for-bottom-side-only-in-swift
		let border = CALayer()
		let width = CGFloat(2.0)
		border.borderColor = UIColor.blueColor().CGColor
		border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width , height: textField.frame.size.height)
		
		border.borderWidth = width
		textField.layer.addSublayer(border)
		textField.layer.masksToBounds = true
	}
	
	func startAcitivityIndicator() {
		// Set Indicatior Active
		activityIndicator.hidden = false
		activityIndicator.startAnimating()
	}
	
	func stopActivityIndicator() {
		activityIndicator.stopAnimating()
		activityIndicator.hidden = true
	}
	
	// MARK: - Geocoding and Map Stuff
	
	func geoCodeAddress(addressString: String) {
		self.startAcitivityIndicator()
		CLGeocoder().geocodeAddressString(addressString, completionHandler: { mark, error in
			dispatch_async(dispatch_get_main_queue(), {
				guard let mark = mark, let firstMark = mark.first else {
					showErrorMessage(withTitle: "No Location found.",
						withErrorMessage: "Couldn't find a Location with the provided Address.",
						viewController: self)
					self.submitButton.enabled = false
					self.activityIndicator.hidden = true
					self.activityIndicator.stopAnimating()
					return
				}
				self.focusOnMap(firstMark)
				self.submitButton.enabled = true
				self.stopActivityIndicator()
			})
		})
	}
	
	func focusOnMap(locationMark: CLPlacemark) {
		self.location = locationMark.location
		let span = MKCoordinateSpan(latitudeDelta: 0.00725, longitudeDelta: 0.00725)
		let region = MKCoordinateRegion(center: locationMark.location!.coordinate, span: span)
		let annotation = MKPointAnnotation()
		annotation.coordinate = locationMark.location!.coordinate
		mapView.setRegion(region, animated: true)
		mapView.addAnnotation(annotation)
	}
	
	// MARK: - Actions
	
	@IBAction func cancel(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func submit(sender: AnyObject) {
		guard let user = SessionManager.shared.user else {
			showErrorMessage(withTitle: "No User Data found.",
			                 withErrorMessage: "Sry Error happened while loading the User Data. Please restart the App.",
			                 viewController: self)
			return
		}
		// Start Loading
		startAcitivityIndicator()
		
		// Submission successful Function
		func submissionSuccessful(studentInformation: StudentInformation) {
			SessionManager.shared.ownInformation = studentInformation
			SessionManager.shared.reloadNecessary = true
			self.dismissViewControllerAnimated(true, completion: nil)
		}
		
		var information = StudentInformation(objectID: "", uniqueKey: user.uniqueKey, firstName: user.firstName, lastName: user.lastName, mapString: self.locationTextField.text!, mediaURL: self.urlTextField.text!, latitude: Float(self.location!.coordinate.latitude), longitude: Float(self.location!.coordinate.longitude), createdAt: NSDate(), updatedAt: NSDate())
		
		if let ownInformation = SessionManager.shared.ownInformation  {
			information.objectID = ownInformation.objectID
			ParseAPI.shared.putStudentInformation(information, withCompletionHandler: {
				dispatch_async(dispatch_get_main_queue(), {
					submissionSuccessful(information)
				})
			}, withErrorHandler: { error in
				self.stopLoadingAndShowError(error)
			})
		} else {
			ParseAPI.shared.postStudentInformation(information, withCompletionHandler: {
				ParseAPI.shared.fetchStudentInformation(information.uniqueKey, withCompletionHandler: { information in
					if let information = information {
						dispatch_async(dispatch_get_main_queue(), {
							submissionSuccessful(information)
						})
					} else {
						self.stopLoadingAndShowError(ResponseMapperError.empty)
					}
				}, withErrorHandler: { error in
					self.stopLoadingAndShowError(error)
				})
				
			}, withErrorHandler: { error in
				self.stopLoadingAndShowError(error)
			})
		}
	}
	
	func stopLoadingAndShowError(error: ErrorType) {
		dispatch_async(dispatch_get_main_queue(), {
			self.stopActivityIndicator()
			showError(error, viewController: self)
		})
	}
	
	// MARK: - Delegates
	
	// MARK: UITextField Delegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		/// To hide the Keyboard on a return Button click
		textField.resignFirstResponder()
		return false
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		if urlTextField === textField {
			// Check if the entered address is valid
			geoCodeAddress(locationTextField.text!)
		}
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		if locationTextField === textField {
			// Check if the entered address is valid
			geoCodeAddress(locationTextField.text!)
		}
	}

}
