//
//  StorageService.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 16/11/19.
//  Copyright © 2019 Piyush. All rights reserved.
//
import Foundation
// this class is used to store data to user default and fetch from user default for whole project
class StorageService {
    
    // MARK: - Variables
    
    /// sharing class Preference
    static let shared = StorageService()
    
    ///  interface for interacting with the defaults system
    let userdefault = UserDefaults.standard
 
    private init() {}
    
    ///
    var strToken: String? {
        get {
            return userdefault.value(forKey: UserDefaults.DefaultKeys.token) as? String
        }
        set {
            if let stadium = newValue {
                userdefault.set(stadium, forKey: UserDefaults.DefaultKeys.token)
            } else {
                userdefault.removeObject(forKey: UserDefaults.DefaultKeys.token)
            }
            userdefault.synchronize()
        }
    }
}
// MARK: - UserDefaults Extension
extension UserDefaults {
    // MARK: - DefaultKeys Name
    struct DefaultKeys {
        ///
        static let token = "Token"
    }
}
