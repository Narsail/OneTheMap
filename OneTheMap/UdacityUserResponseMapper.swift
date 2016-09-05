//
//  UdacityUserResponseMapper.swift
//  OneTheMap
//
//  Created by David Moeller on 02/09/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation

final class UdacityUserResponseMapper: ResponseMapper<UdacityUser>, ResponseMapperProtocol {
	typealias Item = UdacityUser
	
	static func process(obj: AnyObject?) throws -> UdacityUser {
		return try process(obj, parse: { json in
			guard let userDict = json["user"] as? [String: AnyObject] else {
				throw ResponseMapperError.missingAttribute(attribute: "user")
			}
			guard let lastName = userDict["last_name"] as? String else {
				throw ResponseMapperError.missingAttribute(attribute: "last_name")
			}
			guard let firstName = userDict["first_name"] as? String else {
				throw ResponseMapperError.missingAttribute(attribute: "first_name")
			}
			
			guard let uniqueKey = userDict["key"] as? String else {
				throw ResponseMapperError.missingAttribute(attribute: "key")
			}
			return UdacityUser(firstName: firstName, lastName: lastName, uniqueKey: uniqueKey)
			
		})
	}
}