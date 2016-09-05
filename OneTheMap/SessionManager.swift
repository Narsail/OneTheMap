//
//  SessionManager.swift
//  OneTheMap
//
//  Created by David Moeller on 30/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

/// This Manager handles the State of the App

final class SessionManager {
	
	internal static let shared = SessionManager()
	
	var sessionID: String?
	
	var accountKey: String?
	
	var user: UdacityUser?
	
	var ownInformation: StudentInformation?
	
	var studentLocationList = [StudentInformation]() {
		didSet {
			self.reloadNecessary = false
			// Sort the Locations
			self.studentLocationList.sortInPlace({ locationOne, locationTwo in
				return locationOne.updatedAt.compare(locationTwo.updatedAt) == NSComparisonResult.OrderedDescending
			})
		}
	}
	
	var reloadNecessary: Bool = true
	
	private init() {
		
	}
	
}
