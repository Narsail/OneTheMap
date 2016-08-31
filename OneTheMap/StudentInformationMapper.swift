//
//  WorkoutListResponseMapper.swift
//  EMNetwork
//
//  Created by David Moeller on 27/08/16.
//
//

import Foundation

final class StudentInformationResponseMapper: ResponseMapper<StudentInformation>, ResponseMapperProtocol {
	typealias Item = StudentInformation
	
	static func process(obj: AnyObject?) throws -> StudentInformation {
		return try process(obj, parse: { json in
			return try StudentInformation.create(withJsonDictionary: json)
		})
	}
}
