//
//  AppDelegate.swift
//  CollectionViewDynamicHeight
//
//  Created by Admin on 01/12/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _ = ApiManager.sharedInstance
        ApiConfiguration.sharedInstance.buildEnvironment = .development
  

        return true
    }
}

