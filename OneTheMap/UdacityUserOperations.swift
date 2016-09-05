//
//  UdacityUserOperations.swift
//  OneTheMap
//
//  Created by David Moeller on 02/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

public class UdacityUserGETOperation: UdacityServiceOperation {
	
	private let requestItem: UdacityUserGETRequest
	
	internal var success: ((user: UdacityUser) -> Void)?
	internal var failure: ((error: ErrorType) -> Void)?
	
	internal init(request: UdacityUserGETRequest, backendConfiguration: BackendConfiguration, success: ((user: UdacityUser) -> Void)? = nil, failure: ((error: ErrorType) -> Void)? = nil) {
		self.requestItem = request
		self.success = success
		self.failure = failure
		super.init(backendConfiguration: backendConfiguration)
	}
	
	public override func start() {
		super.start()
		service.request(self.requestItem, success: self.handleSuccess, failure: self.handleFailure)
	}
	
	private func handleSuccess(response: AnyObject?) {
		do {
			let user = try UdacityUserResponseMapper.process(response)
			self.success?(user: user)
			self.finish()
		} catch {
			handleFailure(error)
		}
	}
	
	private func handleFailure(error: ErrorType) {
		self.failure?(error: error)
		self.finish()
	}
	
}