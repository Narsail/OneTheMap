//
//  ResponseMapper.swift
//  EMNetwork
//
//  Created by David Moeller on 27/08/16.
//
//

import Foundation

final class ArrayResponseMapper<A: ParsedItem> {
	
	static func process(obj: AnyObject?, mapper: ((AnyObject?) throws -> A)) throws -> [A] {
		guard let json = obj as? [[String: AnyObject]] else { throw ResponseMapperError.invalid }
		
		var items = [A]()
		for jsonNode in json {
			do {
				let item = try mapper(jsonNode)
				items.append(item)
			} catch {
				NSLog("Couldn't create Item because of Error: \(error)")
			}
		}
		return items
	}
}

class ResponseMapper<A: ParsedItem> {
	
	static func process(obj: AnyObject?, parse: (json: [String: AnyObject]) throws -> A) throws -> A {
		guard let json = obj as? [String: AnyObject] else { throw ResponseMapperError.invalid }
		return try parse(json: json)
	}
}

protocol ResponseMapperProtocol {
	associatedtype Item
	static func process(obj: AnyObject?) throws -> Item
}

internal enum ResponseMapperError: ErrorType {
	case invalid
	case missingAttribute(attribute: String)
}
