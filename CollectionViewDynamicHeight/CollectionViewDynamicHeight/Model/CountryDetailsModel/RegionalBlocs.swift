//
//  RegionalBlocs.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 01, 2019
//
import Foundation
import SwiftyJSON

struct RegionalBlocs {

	let name: String?
	let acronym: String?
	let otherNames: [Any]?
	let otherAcronyms: [Any]?

	init(_ json: JSON) {
		name = json["name"].stringValue
		acronym = json["acronym"].stringValue
		otherNames = json["otherNames"].arrayValue.map { $0 }
		otherAcronyms = json["otherAcronyms"].arrayValue.map { $0 }
	}

}