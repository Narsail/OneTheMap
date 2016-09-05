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
	
	func startAcitivityIndicator() {
		// Set Indicatior Active
		activityIndicatorView.hidden = false
		activityIndicatorView.startAnimating()
	}
	
	func stopActivityIndicator() {
		activityIndicatorView.stopAnimating()
		activityIndicatorView.hidden = true
	}
	
	// MARK: - Actions
	
	@IBAction func login(sender: AnyObject) {
		
		// Error Function
		func errorOccurred(error: ErrorType) {
			dispatch_async(dispatch_get_main_queue(), {
				self.stopActivityIndicator()
				showError(error, viewController: self)
				self.enabledInputs(true)
			})
		}
		
		
		guard let email = emailTextField.text where email != "", let password = passwordTextField.text where password != "" else {
			showError(LoginError.NoCredentialsProvided, viewController: self)
			return
		}
		
		startAcitivityIndicator()
		// Disable Input Views like the Textfields and the Login Button
		enabledInputs(false)
		
		// A lot of nested Methods. Could be solved more elegant with the use of a Promise/Result Pattern.
		
		UdacityAPI.shared.login(withEmail: email, withPassword: password, withCompletionHandler: { sessionID, accountKey in
			// Save Session ID
			SessionManager.shared.sessionID = sessionID
			SessionManager.shared.accountKey = accountKey
			
			// Fetch User Data
			UdacityAPI.shared.fetchUserData(withCompletionHandler: { user in
				SessionManager.shared.user = user
				
				// Look/Fetch own Information
				ParseAPI.shared.fetchStudentInformation(user.uniqueKey, withCompletionHandler: { information in
					SessionManager.shared.ownInformation = information
					dispatch_async(dispatch_get_main_queue(), {
						self.stopActivityIndicator()
						self.enabledInputs(true)
						// Segue to Table View
						self.performSegueWithIdentifier("loginSegue", sender: self)
					})
					
				}, withErrorHandler: { error in
					errorOccurred(error)
				})
				
			}, withErrorHandler: { error in
				errorOccurred(error)
			})
		}, withErrorHandler: { error in
			errorOccurred(error)
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
