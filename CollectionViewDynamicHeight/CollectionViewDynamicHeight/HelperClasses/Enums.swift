//
//  Enums.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 16/11/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

/// Enum For Storyboard
enum Storyboard: String {
    ///
    case login = "Main"
    ///
    var filename: String {
        return rawValue
    }
}

/// Enum For DevelopmentEnvironment
enum DevelopmentEnvironment: String {
    ///
    case development = "Development"
    ///
    case production = "Production"
    ///
    case local = "Local"
    ///
    case staging = "Staging"
}

enum CellIdentifier: String {
    case cell = "cell"
}

enum MimeType: String {
    case png = "image/png"
    case jpg = "image/jpg"
    case m4a = "audio/m4a"
}

enum CharacterLimit {
    static let mobileNumber = 15
    static let threeDigit = 3
    static let sixDigit = 6
    static let fourDigit = 4
    static let twenty = 20
    static let ten = 10
}
