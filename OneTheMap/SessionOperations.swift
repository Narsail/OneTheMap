//
//  SessionOperations.swift
//  OneTheMap
//
//  Created by David Moeller on 29/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

enum SessionError: ErrorType {
	case noNSDataFound
	case stringCasting
}

public class SessionPOSTOperation: AuthenticationServiceOperation {
	
	private let requestItem: SessionPOSTRequest
	
	internal var success: ((session: String) -> Void)?
	internal var failure: ((error: ErrorType) -> Void)?
	
	internal init(request: SessionPOSTRequest, backendConfiguration: BackendConfiguration, success: ((session: String) -> Void)? = nil, failure: ((error: ErrorType) -> Void)? = nil) {
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
			let sessionID = try SessionResponseMapper.process(response)
			self.success?(session: sessionID)
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