//
//  AppDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static public var allAvatarsViewController: AllAvatarsViewController? {
        let appDelegate = UIApplication.shared.delegate
        guard let tabbarController = appDelegate?.window??.rootViewController as? UITabBarController else {
            
            return nil
        }
        
        guard let selectedNavigationController = tabbarController.viewControllers?.first as? UINavigationController else {
            
            return nil
        }
        
        guard let allAvatarsViewController = selectedNavigationController.viewControllers.first as? AllAvatarsViewController else {
            return nil
        }
        
        return allAvatarsViewController
    }
    
    func requestPushAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { (granted, error) in
            if granted {
                self.getPushSettings()
            }
        }
    }
    func getPushSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        requestPushAuth()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let params = NSMutableDictionary()
//        let kvPairs : [String] = (url.query?.components(separatedBy: "&"))!
//        for param in  kvPairs{
//            let keyValuePair : Array = param.components(separatedBy: "=")
//            if keyValuePair.count == 2{
//                params.setObject(keyValuePair.last!, forKey: keyValuePair.first! as NSCopying)
//            }
//        }
        
        openCreateController()
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        UNUserNotificationCenter.current().delegate = NotificationManager.shared
        
        return true
    }
  
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        guard let tabbarController = window?.rootViewController as? UITabBarController else {
            return
        }
        
        guard let selectedNavigationController = tabbarController.viewControllers?.first as? UINavigationController else {
            return
        }
        
        guard let allAvatarsViewController = selectedNavigationController.viewControllers.first as? AllAvatarsViewController else {
            return
        }
        
        allAvatarsViewController.isEditing_ = false
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        
        NotificationManager.shared.pushToken = token
        NotificationManager.shared.registerCategories()
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("error push")
    }
    func openCreateController(){
        if let allAvatarsViewController = AppDelegate.allAvatarsViewController {
            allAvatarsViewController.action = .schema
            
            if allAvatarsViewController.isViewLoaded {
                allAvatarsViewController.performSegue(withIdentifier: "createAvatarSegue", sender: nil)
            }
        }
    }
    
}

