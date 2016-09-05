//
//  UdacityUserRequest.swift
//  OneTheMap
//
//  Created by David Moeller on 02/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

struct UdacityUserGETRequest: BackendAPIRequest {
	
	let accountKey: String
	
	var endpoint: String {
		return "users/\(accountKey)"
	}
	
	var method: NetworkService.Method {
		return .GET
	}
	
	var parameters: [String: AnyObject]? {
		return nil
	}
	
	var headers: [String: String]? {
		return self.defaultJSONHeaders()
	}
	
}