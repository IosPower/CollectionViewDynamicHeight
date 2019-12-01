//
//  Translations.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 01, 2019
//
import Foundation
import SwiftyJSON

struct Translations {

	let ja: String?
	let fr: String?
	let br: String?
	let hr: String?
	let nl: String?
	let fa: String?
	let es: String?
	let pt: String?
	let de: String?
	let it: String?

	init(_ json: JSON) {
		ja = json["ja"].stringValue
		fr = json["fr"].stringValue
		br = json["br"].stringValue
		hr = json["hr"].stringValue
		nl = json["nl"].stringValue
		fa = json["fa"].stringValue
		es = json["es"].stringValue
		pt = json["pt"].stringValue
		de = json["de"].stringValue
		it = json["it"].stringValue
	}

}