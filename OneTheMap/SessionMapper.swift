//
//  WorkoutListResponseMapper.swift
//  EMNetwork
//
//  Created by David Moeller on 27/08/16.
//
//

import Foundation

final class SessionResponseMapper: ResponseMapper<[String: String]>, ResponseMapperProtocol {
	typealias Item = [String: String]
	
	static func process(obj: AnyObject?) throws -> [String: String] {
		return try process(obj, parse: { json in
			guard let sessionDict = json["session"] as? [String: AnyObject] else {
				throw ResponseMapperError.missingAttribute(attribute: "session")
			}
			guard let accountDict = json["account"] as? [String: AnyObject] else {
				throw ResponseMapperError.missingAttribute(attribute: "account")
			}
			guard let sessionID = sessionDict["id"] as? String else {
				throw ResponseMapperError.missingAttribute(attribute: "id in session")
			}
			
			guard let accountKey = accountDict["key"] as? String else {
				throw ResponseMapperError.missingAttribute(attribute: "key in account")
			}
			return [
				"sessionID": sessionID,
				"accountKey": accountKey
			]
				
			
		})
	}
}
