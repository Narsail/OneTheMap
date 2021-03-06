//
//  Backend.swift
//  EMClient
//
//  Created by David Moeller on 11/08/16.
//
//

import Foundation

enum BackendServiceError: ErrorType {
	case responseCode(code: Int, response: NSURLResponse)
}

class UdacityService {
	
	private let conf: BackendConfiguration
	private let service: NetworkService!
	
	init(_ conf: BackendConfiguration) {
		self.conf = conf
		self.service = NetworkService()
	}
	
	func request(request: BackendAPIRequest,
	             success: ((AnyObject?) -> Void)? = nil,
	             failure: ((ErrorType) -> Void)? = nil) {
		
		let url = conf.baseURL.URLByAppendingPathComponent(request.endpoint)
		
		var headers = request.headers
		// Set authentication token if available.
		if let auth = self.conf.auth {
			for (key, value) in auth.headerParameters() {
				headers?[key] = value
			}
		}
		
		service.request(url, method: request.method, params: request.parameters, headers: headers, success: { data in
			guard let data = data else {
				failure?(SessionError.noNSDataFound)
				return
			}
			let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
			
			let	json = try? NSJSONSerialization.JSONObjectWithData(newData, options: [])
			success?(json)

		}, failure: { data, error, statusCode, response in
			// Do stuff you need, and call failure block.
			if error != nil {
				failure?(error!)
			} else {
				failure?(BackendServiceError.responseCode(code: statusCode, response: response!))
			}
		})
	}
	
	func cancel() {
		service.cancel()
	}
}

class ParseService {
	
	private let conf: BackendConfiguration
	private let service: NetworkService!
	
	init(_ conf: BackendConfiguration) {
		self.conf = conf
		self.service = NetworkService()
	}
	
	func request(request: BackendAPIRequest,
	             success: ((AnyObject?) -> Void)? = nil,
	             failure: ((ErrorType) -> Void)? = nil) {
		
		var url = NSURL(string: request.endpoint, relativeToURL: conf.baseURL)!
		// Comment: I got no idea why the upper NSURL merging code is producing an URL like:
		// "https://parse.udacity.com/parse/classes/StudentLocation%3where=%7B%22uniqueKey%22:%223062908616%22%7D"
		// The following code is a workaround to get the GET Request at least working.
		if request is StudentInformationGETRequest {
			let urlString = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%223062908616%22%7D"
			url = NSURL(string: urlString)!
		}
		
		var headers = request.headers
		// Set authentication token if available.
		if let auth = self.conf.auth {
			for (key, value) in auth.headerParameters() {
				headers?[key] = value
			}
		}
		
		service.request(url, method: request.method, params: request.parameters, headers: headers, success: { data in
			var json: AnyObject? = nil
			if let data = data {
				json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
			}
			success?(json)
			
			}, failure: { data, error, statusCode, response in
				// Do stuff you need, and call failure block.
				if error != nil {
					failure?(error!)
				} else {
					failure?(BackendServiceError.responseCode(code: statusCode, response: response!))
				}
				
		})
	}
	
	func cancel() {
		service.cancel()
	}
}

class NetworkService {
	
	private var task: NSURLSessionDataTask?
	private var successCodes: Range<Int> = 200..<299
	private var failureCodes: Range<Int> = 400..<499
	
	enum Method: String {
		case GET, POST, PUT, DELETE
	}
	
	func request(url: NSURL, method: Method,
	             params: [String: AnyObject]? = nil,
	             headers: [String: String]? = nil,
	             success: ((NSData?) -> Void)? = nil,
	             failure: ((data: NSData?, error: ErrorType?, responseCode: Int, response: NSURLResponse?) -> Void)? = nil) {
	
		
		let mutableRequest = NSMutableURLRequest(URL: url, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
		                                         timeoutInterval: 10.0)
		mutableRequest.allHTTPHeaderFields = headers
		mutableRequest.HTTPMethod = method.rawValue
		if let params = params {
			mutableRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
		}
		
		let session = NSURLSession.sharedSession()
		task = session.dataTaskWithRequest(mutableRequest, completionHandler: { data, response, error in
			// Decide whether the response is success or failure and call
			// proper callback.
			
			print("Data: \(data)")
			print("response: \(response)")
			print("error: \(error)")
			
			var responseCode = 0
			
			if let response = response as? NSHTTPURLResponse {
				responseCode = response.statusCode
			}
			
			if responseCode >= 300 {
				failure?(data: data, error: error, responseCode: responseCode, response: response)
				return
			}
			
			if data != nil && error == nil {
				success?(data!)
			} else {
				failure?(data: data, error: error, responseCode: responseCode, response: response)
			}
		})
		
		task?.resume()
	}
	
	func cancel() {
		task?.cancel()
	}
}

protocol BackendAPIRequest {
	var endpoint: String { get }
	var method: NetworkService.Method { get }
	var parameters: [String: AnyObject]? { get }
	var headers: [String: String]? { get }
}

extension BackendAPIRequest {
	
	func defaultJSONHeaders() -> [String: String] {
		return [
			"Content-Type": "application/json",
			"Accept": "application/json"
		]
	}
}
