//
//  BackendConfiguration.swift
//  EMClient
//
//  Created by David Moeller on 11/08/16.
//
//

import Foundation

public protocol BackendAuth {
	
	func headerParameters() -> [String: String]
	
}

public final class BackendConfiguration {
	
	let baseURL: NSURL
	let auth: BackendAuth?
	
	public init(baseURL: NSURL, withAuth auth: BackendAuth? = nil) {
		self.auth = auth
		self.baseURL = baseURL
	}
	
	public static var shared: BackendConfiguration?
	
}
