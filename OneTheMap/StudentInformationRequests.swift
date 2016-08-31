//
//  WorkoutListRequest.swift
//  EMNetwork
//
//  Created by David Moeller on 27/08/16.
//
//

import Foundation

struct StudentInformationListGETRequest: BackendAPIRequest {
	
	let limit: Int?
	let skip: Int?
	let order: String?
	
	var endpoint: String {
		
		var endPoint = "classes/StudentLocation"
		
		// This Variable decides whether a ? or & has to be added befor the parameter
		var extended = false
		
		func addParameter(parameterString: String) {
			if !extended {
				endPoint += "?" + parameterString
			} else {
				endPoint += "&" + parameterString
			}
		}
		
		if let limit = limit {
			addParameter("limit=\(limit)")
		}
		
		if let skip = skip {
			addParameter("skip=\(skip)")
		}
		
		if let order = order {
			addParameter("order=\(order)")
		}
		
		return endPoint
	}
	
	var method: NetworkService.Method {
		return .GET
	}
	
	var parameters: [String: AnyObject]? {
		return nil
	}
	
	var headers: [String: String]? {
		return self.defaultJSONHeaders()
	}
	
}

struct StudentInformationGETRequest: BackendAPIRequest {
	
	let uniqueKey: String
	
	var endpoint: String {
		
		return "classes/StudentLocation?where={\"uniqueKey\":\"\(uniqueKey)\"}"
		
	}
	
	var method: NetworkService.Method {
		return .GET
	}
	
	var parameters: [String: AnyObject]? {
		return nil
	}
	
	var headers: [String: String]? {
		return self.defaultJSONHeaders()
	}
	
}

struct StudentInformationPOSTRequest: BackendAPIRequest {
	
	let studentInformation: StudentInformation
	
	var endpoint: String {
		
		return "classes/StudentLocation"
		
	}
	
	var method: NetworkService.Method {
		return .POST
	}
	
	var parameters: [String: AnyObject]? {
		return studentInformation.serialize()
	}
	
	var headers: [String: String]? {
		return self.defaultJSONHeaders()
	}
	
}

struct StudentInformationPUTRequest: BackendAPIRequest {
	
	let studentInformation: StudentInformation
	
	var endpoint: String {
		
		return "classes/StudentLocation/\(studentInformation.objectID)"
		
	}
	
	var method: NetworkService.Method {
		return .PUT
	}
	
	var parameters: [String: AnyObject]? {
		return studentInformation.serialize()
	}
	
	var headers: [String: String]? {
		return self.defaultJSONHeaders()
	}
	
}
