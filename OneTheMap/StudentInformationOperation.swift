//
//  SignalOperation.swift
//  EMNetwork
//
//  Created by David Moeller on 28/08/16.
//
//

import Foundation

public class StudentInformationListGETOperation: DataServiceOperation {
	
	private let requestItem: StudentInformationListGETRequest
	
	internal var success: ((studentInformations: [StudentInformation]) -> Void)?
	internal var failure: ((error: ErrorType) -> Void)?
	
	internal init(request: StudentInformationListGETRequest, backendConfiguration: BackendConfiguration, success: ((studentInformations: [StudentInformation]) -> Void)? = nil, failure: ((error: ErrorType) -> Void)? = nil) {
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
			guard let response = response, let resultsArray = response["results"] as? [AnyObject] else {
				throw ResponseMapperError.invalid
			}
			let studentInformationList = try ArrayResponseMapper.process(resultsArray, mapper: StudentInformationResponseMapper.process)
			self.success?(studentInformations: studentInformationList)
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

public class StudentInformationGETOperation: DataServiceOperation {
	
	private let requestItem: StudentInformationGETRequest
	
	internal var success: ((studentInformation: StudentInformation) -> Void)?
	internal var failure: ((error: ErrorType) -> Void)?
	
	internal init(request: StudentInformationGETRequest, backendConfiguration: BackendConfiguration, success: ((studentInformation: StudentInformation) -> Void)? = nil, failure: ((error: ErrorType) -> Void)? = nil) {
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
			let studentInformation = try StudentInformationResponseMapper.process(response)
			self.success?(studentInformation: studentInformation)
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

public class StudentInformationPOSTOperation: DataServiceOperation {
	
	private let requestItem: StudentInformationPOSTRequest
	
	internal var success: ((Void) -> Void)?
	internal var failure: ((error: ErrorType) -> Void)?
	
	internal init(request: StudentInformationPOSTRequest, backendConfiguration: BackendConfiguration, success: ((Void) -> Void)? = nil, failure: ((error: ErrorType) -> Void)? = nil) {
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
		self.success?()
	}
	
	private func handleFailure(error: ErrorType) {
		self.failure?(error: error)
		self.finish()
	}
	
}

public class StudentInformationPUTOperation: DataServiceOperation {
	
	private let requestItem: StudentInformationPUTRequest
	
	internal var success: ((Void) -> Void)?
	internal var failure: ((error: ErrorType) -> Void)?
	
	internal init(request: StudentInformationPUTRequest, backendConfiguration: BackendConfiguration, success: ((Void) -> Void)? = nil, failure: ((error: ErrorType) -> Void)? = nil) {
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
		self.success?()
	}
	
	private func handleFailure(error: ErrorType) {
		self.failure?(error: error)
		self.finish()
	}
	
}