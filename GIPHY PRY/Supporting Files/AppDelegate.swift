//
//  AppDelegate.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 9/30/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        
        let pryViewController  = PryViewController()
        window.rootViewController = UINavigationController(rootViewController: pryViewController)
        window.makeKeyAndVisible()
        
        UISearchBar.appearance().tintColor = .white
        UISearchBar.appearance().barStyle = .black
        UISearchBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = true
        
        return true
    }
}

