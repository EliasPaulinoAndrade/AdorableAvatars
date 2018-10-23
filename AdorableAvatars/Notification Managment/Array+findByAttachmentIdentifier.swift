//
//  UNNotificationAttachment+.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 23/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UserNotifications
import UIKit

extension Array where Element: UNNotificationAttachment {
    public func findByAttachmentIdentifier(identifier: String) -> UIImage? {
        for attachment in self {
            if attachment.identifier == "notification_image", let image = try? UIImage.init(url: attachment.url) {
                
                return image
            }
        }
        return nil
    }
}
