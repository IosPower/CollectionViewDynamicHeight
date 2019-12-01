//
//  Currencies.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 01, 2019
//
import Foundation
import SwiftyJSON

struct Currencies {

	let name: String?
	let code: String?
	let symbol: String?

	init(_ json: JSON) {
		name = json["name"].stringValue
		code = json["code"].stringValue
		symbol = json["symbol"].stringValue
	}

}