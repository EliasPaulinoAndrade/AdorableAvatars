//
//  NotificationManager.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 22/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static public var shared = NotificationManager.init()
    
    public var pushToken: String?

    private override init() {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       
        print("eae")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        return completionHandler([.alert, .badge, .sound])
    }
}
