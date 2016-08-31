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
	
	func login(withEmail email: String, withPassword password: String, withCompletionHandler completionHandler: ((sessionID: String) -> Void)? = nil, withErrorHandler errorHandler: ((error: ErrorType) -> Void)? = nil) {
		let loginRequest = SessionPOSTRequest(username: email, password: password)
		let loginOperation = SessionPOSTOperation(request: loginRequest, backendConfiguration: configuration, success: { sessionID in
			completionHandler?(sessionID: sessionID)
		}, failure: { error in
			errorHandler?(error: error)
		})
		backendQueue.addOperation(loginOperation)
	}
	

	
}
	