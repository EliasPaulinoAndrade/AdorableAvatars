//
//  NotificationManager.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 22/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static public var shared = NotificationManager.init()
    
    public var pushToken: String?

    private override init() {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       
        switch response.actionIdentifier {
        case ActionID.avatarOfDaySave.rawValue:
            print("eae")
            openCreateController()
        
        default:
            print("no one")
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        return completionHandler([.alert, .badge, .sound])
    }
    
    func registerCategories(){
        
        let action = UNNotificationAction.init(identifier: ActionID.avatarOfDaySave.rawValue, title: "Save", options: .foreground)
        
        let category = UNNotificationCategory.init(identifier: CategoryID.avatarOfDay.rawValue, actions: [action], intentIdentifiers: [], options: [UNNotificationCategoryOptions.customDismissAction])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    func openCreateController(){
        let appDelegate = UIApplication.shared.delegate
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        guard let controller = storyboard.instantiateViewController(withIdentifier: "CreateAvatarNavigationControllerID") as? UINavigationController else {
            return
        }
        
        guard let tabbarController = appDelegate?.window??.rootViewController as? UITabBarController else {
            
            return
        }
        guard let selectedNavigationController = tabbarController.viewControllers?.first as? UINavigationController else {
            
            return
        }
        
        guard let allAvatarsViewController = selectedNavigationController.viewControllers.first as? AllAvatarsViewController else {
            return
        }
        
        
        appDelegate?.window??.rootViewController?.present(controller, animated: true, completion: nil)
        
    }
}
