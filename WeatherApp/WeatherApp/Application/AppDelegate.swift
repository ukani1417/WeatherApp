//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Dhruv Ukani on 16/10/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        window?.rootViewController = WeatherTBC()
        window?.makeKeyAndVisible()
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print(paths[0])
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        PersistentStorage.shared.saveContext()
    }
}

