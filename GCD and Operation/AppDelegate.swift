//
//  AppDelegate.swift
//  GCD and Operation
//
//  Created by Егор Никитин on 29.01.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationViewController = UINavigationController(rootViewController: ViewController())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
        
        return true
    }

}

