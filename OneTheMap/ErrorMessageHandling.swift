//
//  ErrorMessageHandling.swift
//  OneTheMap
//
//  Created by David Moeller on 05/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import UIKit

func showError(error: ErrorType, viewController: UIViewController) {
	let (title, message) = errorMessageComponents(error)
	
	showErrorMessage(withTitle: title, withErrorMessage: message, viewController: viewController)
}

func showErrorMessage(withTitle title: String, withErrorMessage errorMessage: String, viewController: UIViewController) {
	// Present the Alert View
	let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
	alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
	viewController.presentViewController(alert, animated: true, completion: nil)
}

func errorMessageComponents(error: ErrorType) -> (String, String) {
	var title = ""
	var message = ""
	switch error {
	case LoginError.NoCredentialsProvided:
		title = "Credentials are missing."
		message = "Please provide an Email and a Password for the Login."
	case BackendServiceError.responseCode(code: let code) where code == 403:
		title = "Incorrect Credentials."
		message = "Your Email or password was incorrect."
	default:
		let nsError = error as NSError
		switch nsError.code {
		case -1001, -1005, -1009:
			title = "No Internet Connection."
			message = "Please check your Internet connection and try again."
		default:
			title = "An Error occurred."
			message = "Error: \(nsError)"
		}
	}
	return (title, message)
}