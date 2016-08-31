//
//  LoginViewController.swift
//  OneTheMap
//
//  Created by David Moeller on 30/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!

	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
	
	// MARK: - View Controller LifeCycle
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		subscribeToKeyboardNotifications()
		
		configureTextField(emailTextField)
		configureTextField(passwordTextField)
		
		activityIndicatorView.hidden = true
	}
	
	override func viewDidDisappear(animated: Bool) {
		unsubscribeToKeyboardNotifications()
		super.viewDidDisappear(animated)
	}
	
	// MARK: - Views
	
	func configureTextField(textField: UITextField) {
		textField.delegate = self
	}
	
	func enabledInputs(enabled: Bool) {
		emailTextField.enabled = enabled
		passwordTextField.enabled = enabled
		loginButton.enabled = enabled
	}
	
	// MARK: - Internal Methods
	
	func showErrorMessage(error: ErrorType) {
		// Set the Error Title and Message
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
			title = "An Error occurred."
			message = "Error: \(error)"
		}
		
		// Present the Alert View
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
		self.presentViewController(alert, animated: true, completion: nil)
		return
	}
	
	// MARK: - Actions
	
	@IBAction func login(sender: AnyObject) {
		guard let email = emailTextField.text where email != "", let password = passwordTextField.text where password != "" else {
			showErrorMessage(LoginError.NoCredentialsProvided)
			return
		}
		// Set Indicatior Active
		activityIndicatorView.hidden = false
		activityIndicatorView.startAnimating()
		// Disable Input Views like the Textfields and the Login Button
		enabledInputs(false)
		
		UdacityAPI.shared.login(withEmail: email, withPassword: password, withCompletionHandler: { sessionID in
			dispatch_async(dispatch_get_main_queue(), {
				// Save Session ID
				SessionManager.shared.set(sessionID)
				// Segue to Table View
				self.performSegueWithIdentifier("loginSegue", sender: self)
			})
		}, withErrorHandler: { error in
			dispatch_async(dispatch_get_main_queue(), {
				self.activityIndicatorView.stopAnimating()
				self.activityIndicatorView.hidden = true
				self.showErrorMessage(error)
				self.enabledInputs(true)
			})
		})
	}
	
	// MARK: - Keyboard Stuff
	
	func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func unsubscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func keyboardWillShow(notification: NSNotification){
		if emailTextField.isFirstResponder() || passwordTextField.isFirstResponder() {
			let distanceBetweenLoginButtonAndBottom = view.bounds.height - loginButton.frame.origin.y - loginButton.bounds.height - 10 // Offset
			view.frame.origin.y = 0 - getKeyboardHeight(notification) + distanceBetweenLoginButtonAndBottom
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		view.frame.origin.y = 0
	}
	
	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		
		guard let userInfo = notification.userInfo as? [String: AnyObject] else {
			return 0
		}
		guard let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
			return 0
		}
		
		return keyboardSize.CGRectValue().height
	}
	
	// MARK: UITextField Delegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}

}

enum LoginError: ErrorType {
	case NoCredentialsProvided
}
