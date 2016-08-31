//
//  ParseAuth.swift
//  OneTheMap
//
//  Created by David Moeller on 29/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

struct ParseAuth: BackendAuth {
	
	let applicationID: String
	let restApiKey: String
	
	init(applicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", restApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY") {
		self.applicationID = applicationID
		self.restApiKey = restApiKey
	}
	
	func headerParameters() -> [String : String] {
		return [
			"X-Parse-Application-Id": applicationID,
			"X-Parse-REST-API-Key": restApiKey
		]
	}
	
}