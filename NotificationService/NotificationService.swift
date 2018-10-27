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
            
            guard let formattedContent = bestAttemptContent.userInfo["aps"] as? [String: Any] else {
                contentHandler(bestAttemptContent)
                return
            }
            
            let avatar = ADAvatar.init(withDictionary: formattedContent)
            
            adWrapper.delegate = self
            adWrapper.getImage(for: avatar)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

extension NotificationService: ADAvatarDelegate {
    func didLoadAvatarImage(wrapper: ADWrapper, image: UIImage) {
        if let imageURL = FileManager.default.saveAvatarImage(image, withName: "notification_image"){
            if let attachment = try? UNNotificationAttachment.init(identifier: "notification_image", url: imageURL, options: [:]) {
                bestAttemptContent?.attachments.append(attachment)
                
                if let bestAttemptContent = self.bestAttemptContent {
                    self.contentHandler?(bestAttemptContent)
                }
            }
        }
    }
    
    func avatarLoadDidFail(wrapper: ADWrapper, for avatar: ADAvatar) {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
