//
//  MapViewController.swift
//  OneTheMap
//
//  Created by David Moeller on 30/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

	// Main View
	@IBOutlet weak var mapView: MKMapView!
	
	private var studentInformationList: [StudentInformation] {
		return SessionManager.shared.studentLocationList
	}
	
	// MARK: - Controller LifeCycle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		mapView.delegate = self
		
		setReloadView()
		
		if SessionManager.shared.reloadNecessary {
			fetchStudentInformationList()
		}
	}
	
	// MARK: - View Settings
	
	func setReloadView() {
		let reloadView = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(MapViewController.reload(_:)))
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
		setLoadingView()
		ParseAPI.shared.fetchStudentInformationList(withCompletionHandler: { list in
			SessionManager.shared.studentLocationList = list
			dispatch_async(dispatch_get_main_queue(), {
				self.setReloadView()
				self.showAnnotations()
			})
		}, withErrorHandler: { error in
			dispatch_async(dispatch_get_main_queue(), {
				showError(error, viewController: self)
				self.setReloadView()
			})
		})
	}
	
	func showAnnotations() {
		// Remove all Annotations
		mapView.removeAnnotations(mapView.annotations)
		// Add the full list
		let annotations = studentInformationList.map({ StudentInformationAnnotation.init(studentInformation: $0) })
		mapView.addAnnotations(annotations)
		// Zoom out to show all Annotations
		mapView.showAnnotations(mapView.annotations, animated: true)
	}
	
	// MARK: - Delegate Methods
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		guard let annotation = annotation as? StudentInformationAnnotation else {
			return nil
		}
		
		// This code has been inspired by https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
		
		let identifier = "StudentInformationPin"
		
		var view: MKPinAnnotationView
		if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
			dequeuedView.annotation = annotation
			view = dequeuedView
		} else {
			view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			view.canShowCallout = true
			view.calloutOffset = CGPoint(x: -5, y: 5)
			view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
		}
		return view
	}
	
	func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		let studentAnnotationView = view.annotation as! StudentInformationAnnotation
		
		func showURLError() {
			showErrorMessage(withTitle: "No URL provided.", withErrorMessage: "The selected Entry doesn't provide a valid URL.", viewController: self)
		}
		
		let urlString = studentAnnotationView.studentInformation.mediaURL
		guard urlString != "", let url = NSURL(string: urlString) else {
			showURLError()
			return
		}
		if UIApplication.sharedApplication().canOpenURL(url) {
			UIApplication.sharedApplication().openURL(url)
		} else {
			showURLError()
		}
	}
}
