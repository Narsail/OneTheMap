//
//  UdacityAPI.swift
//  OneTheMap
//
//  Created by David Moeller on 29/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

final class UdacityAPI {
	
	internal static let shared = UdacityAPI()
	
	let backendQueue = NSOperationQueue()
	let configuration: BackendConfiguration
	
	private init() {
		configuration = BackendConfiguration(baseURL: NSURL(string: "https://www.udacity.com/api/")!)
	}
	
	/// Login through the Udacity API and fetch the Session ID
	
	func login(withEmail email: String, withPassword password: String, withCompletionHandler completionHandler: ((sessionID: String, accountKey: String) -> Void)? = nil, withErrorHandler errorHandler: ((error: ErrorType) -> Void)? = nil) {
		let loginRequest = SessionPOSTRequest(username: email, password: password)
		let loginOperation = SessionPOSTOperation(request: loginRequest, backendConfiguration: configuration, success: { sessionID, accountKey in
			completionHandler?(sessionID: sessionID, accountKey: accountKey)
		}, failure: { error in
			errorHandler?(error: error)
		})
		backendQueue.addOperation(loginOperation)
	}
	
	/// Fetch User Data
	
	func fetchUserData(withCompletionHandler completionHandler: ((user: UdacityUser) -> Void), withErrorHandler errorHandler: ((error: ErrorType) -> Void)) {
		guard let accountKey = SessionManager.shared.accountKey else {
			errorHandler(error: UdacityAPIError.AccountKeyMissing)
			return
		}
		let userRequest = UdacityUserGETRequest(accountKey: accountKey)
		let userOperation = UdacityUserGETOperation(request: userRequest, backendConfiguration: configuration, success: { user in
			completionHandler(user: user)
		}, failure: { error in
			errorHandler(error: error)
		})
		backendQueue.addOperation(userOperation)
	}

	
}

enum UdacityAPIError: ErrorType {
	case AccountKeyMissing
}
	