//
//  Languages.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 01, 2019
//
import Foundation
import SwiftyJSON

struct Languages {

	let name: String?
	let iso6391: String?
	let nativeName: String?
	let iso6392: String?

	init(_ json: JSON) {
		name = json["name"].stringValue
		iso6391 = json["iso639_1"].stringValue
		nativeName = json["nativeName"].stringValue
		iso6392 = json["iso639_2"].stringValue
	}

}