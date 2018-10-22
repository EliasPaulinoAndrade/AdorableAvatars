//
//  NotificationService.swift
//  NotificationService
//
//  Created by Elias Paulino on 22/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    private var adWrapper: ADWrapper = ADWrapper.init()

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            
            let avatar = ADAvatar.init(
                eye: bestAttemptContent.userInfo["eye"] as? Int,
                nose: bestAttemptContent.userInfo["nose"] as? Int,
                month: bestAttemptContent.userInfo[""] as? Int,
                color: UIColor.red)
            
            adWrapper.delegate = self
            adWrapper.getImage(for: avatar)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

extension NotificationService: ADDelegate {
    func didLoadAvatarTypes(wrapper: ADWrapper) {
        
    }
    
    func didLoadAvatarImage(wrapper: ADWrapper, image: UIImage) {
        
        if let imageURL = FileManager.default.saveTemporaryAvatarImage(image: image){
            if let attachment = try? UNNotificationAttachment.init(identifier: "notification_image", url: imageURL, options: [:]) {
                bestAttemptContent?.attachments.append(attachment)
                
                if let bestAttemptContent = self.bestAttemptContent {
                    self.contentHandler?(bestAttemptContent)
                }
            }
        }
    }
    
    func avatarLoadDidFail(wrapper: ADWrapper, for avatar: ADAvatar) {
        
    }
    
    func avatarTypesLoadDidFail(wrapper: ADWrapper) {
        
    }
}
