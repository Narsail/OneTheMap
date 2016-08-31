//
//  StudentLocation.swift
//  OneTheMap
//
//  Created by David Moeller on 28/08/2016.
//  Copyright © 2016 David Moeller. All rights reserved.
//

import Foundation
import MapKit

class StudentInformationAnnotation: NSObject, MKAnnotation {
	
	let studentInformation: StudentInformation
	
	// Annotation Properties
	var title: String? {
		return "\(studentInformation.firstName) \(studentInformation.lastName)"
	}
	
	var subtitle: String? {
		return studentInformation.mediaURL
	}
	
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: CLLocationDegrees(studentInformation.latitude), longitude: CLLocationDegrees(studentInformation.longitude))
	}
	
	init(studentInformation: StudentInformation) {
		self.studentInformation = studentInformation
	}
	
}

struct StudentInformation {
	
	let objectID: String
	let uniqueKey: String
	let firstName: String
	let lastName: String
	let mapString: String
	let mediaURL: String
	let latitude: Float
	let longitude: Float
	let createdAt: NSDate
	let updatedAt: NSDate
	
	static let dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
	
	func serialize() -> [String: AnyObject] {
		return [
			"uniqueKey": uniqueKey,
			"firstName": firstName,
			"lastName": lastName,
			"mapString": mapString,
			"mediaURL": mediaURL,
			"latitude": latitude,
			"longitude": longitude
		]
	}
	
	static func create(withJsonDictionary json: [String: AnyObject]) throws -> StudentInformation {
		
		guard let objectID = json["objectId"] as? String else {
			throw ResponseMapperError.missingAttribute(attribute: "objectId")
		}
		guard let uniqueKey = json["uniqueKey"] as? String else {
			throw ResponseMapperError.missingAttribute(attribute: "uniqueKey")
		}
		guard let firstName = json["firstName"] as? String else {
			throw ResponseMapperError.missingAttribute(attribute: "firstName")
		}
		guard let lastName = json["lastName"] as? String else {
			throw ResponseMapperError.missingAttribute(attribute: "lastName")
		}
		guard let mediaURL = json["mediaURL"] as? String else {
			throw ResponseMapperError.missingAttribute(attribute: "mediaURL")
		}
		guard let mapString = json["mapString"] as? String else {
			throw ResponseMapperError.missingAttribute(attribute: "mapString")
		}
		guard let createdAtString = json["createdAt"] as? String, let createdAt = NSDate.dateFromString(createdAtString, format: dateFormat) else {
			throw ResponseMapperError.missingAttribute(attribute: "createdAt")
		}
		guard let updatedAtString = json["updatedAt"] as? String, let updatedAt = NSDate.dateFromString(updatedAtString, format: dateFormat) else {
			throw ResponseMapperError.missingAttribute(attribute: "updatedAt")
		}
		guard let latitude = json["latitude"] as? Float else {
			throw ResponseMapperError.missingAttribute(attribute: "latitude")
		}
		guard let longitude = json["longitude"] as? Float else {
			throw ResponseMapperError.missingAttribute(attribute: "longitude")
		}
		
		return StudentInformation(objectID: objectID, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude, createdAt: createdAt, updatedAt: updatedAt)
		
	}
	
}

extension NSDate {
	
	static func dateFromString(date: String, format: String) -> NSDate? {
		let formatter = NSDateFormatter()
		formatter.dateFormat = format
		return formatter.dateFromString(date)
	}
	
}