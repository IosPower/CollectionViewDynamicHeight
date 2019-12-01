//
//  ApiConfiguration.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 16/11/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

/// This will give base URL for API call according to the environment.
class ApiConfiguration: NSObject {

    ///
    var baseURL: String = ""
    ///
    var serverURL: String = ""
    /// Time Interval in second for request time out
    static let timeoutIntervalForRequest = 100.0
    /// Time Interval in second for resource time out
    static let timeoutIntervalForResource = 100.0
    // MARK: - Init
    ///
    fileprivate override init() {
        // build environment set
        self.buildEnvironment = .development
        super.init()
    }
    ///
    class var sharedInstance: ApiConfiguration {
        struct Static {
            static var instance: ApiConfiguration?
            static var token: Int = 0
        }
        if Static.instance == nil {
            Static.instance = ApiConfiguration()
        }
        return Static.instance ?? ApiConfiguration()
    }
    /// Setup build environment for application.
    var buildEnvironment: DevelopmentEnvironment {
        didSet {
            switch buildEnvironment {
            case .production:
                baseURL = ""
            case .staging:
                baseURL = ""
            case .development:
                baseURL = "https://www.restcountries.eu/rest/v2"
            default:
                //baseURL = ""
                baseURL = ""
            }
            serverURL = baseURL + "/"
        }
    }
}
