//
//  ParsedItems.swift
//  EMNetwork
//
//  Created by David Moeller on 27/08/16.
//
//

import Foundation

extension StudentInformation: ParsedItem {
	
}

extension String: ParsedItem {
	
}

extension Dictionary: ParsedItem {
	
}

extension UdacityUser: ParsedItem {
	
}

public protocol ParsedItem {}
