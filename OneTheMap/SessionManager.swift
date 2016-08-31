//
//  SessionManager.swift
//  OneTheMap
//
//  Created by David Moeller on 30/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

final class SessionManager {
	
	internal static let shared = SessionManager()
	
	private(set) var sessionID: String?
	private(set) var studentLocationList = [StudentInformation]()
	
	var reloadNecessary: Bool {
		return studentLocationList.isEmpty
	}
	
	private init() {
		
	}
	
	func set(sessionID: String) {
		self.sessionID = sessionID
	}
	
	func set(studentLocationList: [StudentInformation]) {
		self.studentLocationList = studentLocationList
	}
	
}
