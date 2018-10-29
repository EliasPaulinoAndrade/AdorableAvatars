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
            saveAvatarTapped(content: response.notification.request.content)
        default:
            break
        }
        
        completionHandler()
    }
    
    private func saveAvatarTapped(content: UNNotificationContent?) {
        guard let formattedContent = content?.userInfo["aps"] as? [String: Any] else {
            return
        }
        
        let avatar = ADAvatar.init(withDictionary: formattedContent)
        AppHelper.openAllAvatarsViewControllerFromPush(adAvatar: avatar)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        return completionHandler([.alert, .badge, .sound])
    }
    
    func registerCategories(){
        
        let action = UNNotificationAction.init(identifier: ActionID.avatarOfDaySave.rawValue, title: "Save Avatar", options: .foreground)
        
        let category = UNNotificationCategory.init(identifier: CategoryID.avatarOfDay.rawValue, actions: [action], intentIdentifiers: [], options: [UNNotificationCategoryOptions.customDismissAction])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

