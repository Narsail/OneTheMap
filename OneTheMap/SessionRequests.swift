//
//  SessionRequests.swift
//  OneTheMap
//
//  Created by David Moeller on 29/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

struct SessionPOSTRequest: BackendAPIRequest {
	
	let username: String
	let password: String
	
	var endpoint: String {
		return "session"
	}
	
	var method: NetworkService.Method {
		return .POST
	}
	
	var parameters: [String: AnyObject]? {
		return [
			"udacity": [
				"username": username,
				"password": password
			]
		]
	}
	
	var headers: [String: String]? {
		return self.defaultJSONHeaders()
	}
	
}