//
//  ParseAPI.swift
//  OneTheMap
//
//  Created by David Moeller on 28/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

// Comment: The whole structure of the Network Layer is written according to the following Blog Entry:
// http://szulctomasz.com/how-do-I-build-a-network-layer/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS_Dev_Weekly_Issue_263

final class ParseAPI {
	
	internal static let shared = ParseAPI()
	
	let backendQueue = NSOperationQueue()
	let configuration: BackendConfiguration
	
	private init() {
		let auth = ParseAuth()
		configuration = BackendConfiguration(baseURL: NSURL(string: "https://parse.udacity.com/parse/")!, withAuth: auth)
	}
	
	/// Fetch a List of Student Locations
	func fetchStudentInformationList(withCompletionHandler completionHandler: (studentInformationList: [StudentInformation]) -> (Void), withErrorHandler errorHandler: (error: ErrorType) -> Void) {
		let request = StudentInformationListGETRequest(limit: nil, skip: nil, order: nil)
		let studentInformationListOperation = StudentInformationListGETOperation(request: request, backendConfiguration: configuration, success: { list in
			completionHandler(studentInformationList: list)
		}, failure: { error in
			errorHandler(error: error)
		})
		backendQueue.addOperation(studentInformationListOperation)
	}
	
	/// Fetch a Student Location
	func fetchStudentInformation(uniqueKey: String, withCompletionHandler completionHandler: (studentInformation: StudentInformation?) -> (Void), withErrorHandler errorHandler: (error: ErrorType) -> Void) {
		let request = StudentInformationGETRequest(uniqueKey: uniqueKey)
		let studentInformationListOperation = StudentInformationGETOperation(request: request, backendConfiguration: configuration, success: { location in
			completionHandler(studentInformation: location)
		}, failure: { error in
				errorHandler(error: error)
		})
		backendQueue.addOperation(studentInformationListOperation)
	}
	
	/// Post a Student Location
	func postStudentInformation(studentInformation: StudentInformation, withCompletionHandler completionHandler: (Void) -> (Void), withErrorHandler errorHandler: (error: ErrorType) -> Void) {
		let request = StudentInformationPOSTRequest(studentInformation: studentInformation)
		let studentInformationListOperation = StudentInformationPOSTOperation(request: request, backendConfiguration: configuration, success: { _ in
			completionHandler()
		}, failure: { error in
			errorHandler(error: error)
		})
		backendQueue.addOperation(studentInformationListOperation)
	}
	
	/// Put a Student Location
	func putStudentInformation(studentInformation: StudentInformation, withCompletionHandler completionHandler: (Void) -> (Void), withErrorHandler errorHandler: (error: ErrorType) -> Void) {
		let request = StudentInformationPUTRequest(studentInformation: studentInformation)
		let studentInformationListOperation = StudentInformationPUTOperation(request: request, backendConfiguration: configuration, success: { _ in
			completionHandler()
		}, failure: { error in
			errorHandler(error: error)
		})
		backendQueue.addOperation(studentInformationListOperation)
	}
	
}