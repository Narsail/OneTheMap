//
//  WorkoutListResponseMapper.swift
//  EMNetwork
//
//  Created by David Moeller on 27/08/16.
//
//

import Foundation

final class SessionResponseMapper: ResponseMapper<String>, ResponseMapperProtocol {
	typealias Item = String
	
	static func process(obj: AnyObject?) throws -> String {
		return try process(obj, parse: { json in
			guard let sessionDict = json["session"] as? [String: AnyObject] else {
				throw ResponseMapperError.missingAttribute(attribute: "session")
			}
			guard let sessionID = sessionDict["id"] as? String else {
				throw ResponseMapperError.missingAttribute(attribute: "id")
			}
			return sessionID
		})
	}
}
