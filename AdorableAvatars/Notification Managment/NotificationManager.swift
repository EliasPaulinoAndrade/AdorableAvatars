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
            let image = FileManager.default.getAvatar(withName: "notification_image")
            openCreateController(image: image)
            //if let image = response.notification.request.content.attachments.findByAttachmentIdentifier(identifier: "notification_image") {
            
            
            //}
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

    func openCreateController(image: UIImage?){
        let appDelegate = UIApplication.shared.delegate
        
        guard let tabbarController = appDelegate?.window??.rootViewController as? UITabBarController else {
            
            return
        }
        guard let selectedNavigationController = tabbarController.viewControllers?.first as? UINavigationController else {
            
            return
        }
        
        guard let allAvatarsViewController = selectedNavigationController.viewControllers.first as? AllAvatarsViewController else {
            return
        }
        
        allAvatarsViewController.action = .push
        allAvatarsViewController.data = AllAvatarsViewControllerReceivedData(initialCreationImage: image)
        
        if allAvatarsViewController.isViewLoaded {
            allAvatarsViewController.performSegue(withIdentifier: "createAvatarSegue", sender: nil)
        }
    }

}
