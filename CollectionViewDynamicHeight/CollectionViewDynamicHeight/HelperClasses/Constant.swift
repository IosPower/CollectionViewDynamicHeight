//
//  Constant.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 16/11/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

/// It will be having all constant value by which we can able to access those value from different class.
class Constant: NSObject {
    
    private override init() { }
    
    // MARK: - Variable
    ///
    static let screenWidth = UIScreen.main.bounds.size.width
    ///
    static let screenHeight = UIScreen.main.bounds.size.height
    ///
    static let AppDel = UIApplication.shared.delegate as? AppDelegate
    ///
    static let defaults = UserDefaults.standard
    ///
    static var navController: UINavigationController!
    ///
    static let storeService = StorageService.shared
    ///
    static let window = Constant.AppDel?.window
}
