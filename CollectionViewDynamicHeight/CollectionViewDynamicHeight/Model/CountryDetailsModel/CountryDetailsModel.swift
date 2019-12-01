//
//  CountryDetailsModel.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on December 01, 2019
//
import Foundation
import SwiftyJSON

struct CountryDetailsModel {

	let capital: String?
	let subregion: String?
	let numericCode: String?
	let callingCodes: [String]?
	let translations: Translations?
	let topLevelDomain: [String]?
	let population: Int?
	let flag: String?
	let region: String?
	let nativeName: String?
	let area: Int?
	let demonym: String?
	let gini: Double?
	let alpha2Code: String?
	let borders: [String]?
	let latlng: [Int]?
	let regionalBlocs: [RegionalBlocs]?
	let altSpellings: [String]?
	let currencies: [Currencies]?
	let languages: [Languages]?
	let timezones: [String]?
	let alpha3Code: String?
	let cioc: String?
	let name: String?

	init(_ json: JSON) {
		capital = json["capital"].stringValue
		subregion = json["subregion"].stringValue
		numericCode = json["numericCode"].stringValue
		callingCodes = json["callingCodes"].arrayValue.map { $0.stringValue }
		translations = Translations(json["translations"])
		topLevelDomain = json["topLevelDomain"].arrayValue.map { $0.stringValue }
		population = json["population"].intValue
		flag = json["flag"].stringValue
		region = json["region"].stringValue
		nativeName = json["nativeName"].stringValue
		area = json["area"].intValue
		demonym = json["demonym"].stringValue
		gini = json["gini"].doubleValue
		alpha2Code = json["alpha2Code"].stringValue
		borders = json["borders"].arrayValue.map { $0.stringValue }
		latlng = json["latlng"].arrayValue.map { $0.intValue }
		regionalBlocs = json["regionalBlocs"].arrayValue.map { RegionalBlocs($0) }
		altSpellings = json["altSpellings"].arrayValue.map { $0.stringValue }
		currencies = json["currencies"].arrayValue.map { Currencies($0) }
		languages = json["languages"].arrayValue.map { Languages($0) }
		timezones = json["timezones"].arrayValue.map { $0.stringValue }
		alpha3Code = json["alpha3Code"].stringValue
		cioc = json["cioc"].stringValue
		name = json["name"].stringValue
	}

}