//
//  AppDelegate.swift
//  SwiftBasicToolDemo
//
//  Created by Stephen.Zeng on 2022/1/20.
//

import UIKit
import SwiftBasicTool

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard #available(iOS 13, *) else {
            print("return if lower than iOS 13")
            createWindow()
            return true
        }
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    fileprivate func createWindow() {
        window = UIWindow()
        AppDelegate.setupWindow(window: window)
    }
    
    class func setupWindow(window: UIWindow?) {
        window?.makeKey()
//        UINavigationController(rootViewController: ViewController())
//        ViewController()
        window?.rootViewController = BaseNavigationViewController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
    }
}
