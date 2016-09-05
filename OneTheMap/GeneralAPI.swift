//
//  GeneralAPI.swift
//  OneTheMap
//
//  Created by David Moeller on 02/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

class GeneralAPI {
	
	static func fetchStudentLocations(withCompletionHandler completionHandler: (Void) -> (Void), withErrorHandler errorHandler: (error: ErrorType) -> Void) {
		// Fetch User Data
		UdacityAPI.shared.fetchUserData(withCompletionHandler: { user in
			SessionManager.shared.user = user
			
			// Fetch Location 
			ParseAPI.shared.fetchStudentInformationList(withCompletionHandler: { list in
				SessionManager.shared.studentLocationList = list
				completionHandler()
				// Fetch own Location
				guard let user = SessionManager.shared.user else {
					return
				}
				ParseAPI.shared.fetchStudentInformation(user.uniqueKey, withCompletionHandler: { location in
					SessionManager.shared.ownLocationExists = true
				}, withErrorHandler: { error in
					NSLog("Error happened while fetching own Location: \(error) with Key: \(user.uniqueKey)")
				})
				
				
			}, withErrorHandler: { error in
					errorHandler(error: error)
			})
			
			
		}, withErrorHandler: { error in
			errorHandler(error: error)
		})
		
	}
}