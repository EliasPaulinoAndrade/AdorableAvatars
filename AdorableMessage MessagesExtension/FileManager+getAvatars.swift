//
//  FileManager+avatarArray.swift
//  AdorableMessage MessagesExtension
//
//  Created by Elias Paulino on 26/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension FileManager {
    
    func getAvatars() -> [AvatarContainer] {
        
        let avatarUrls: [URL]? = self.getAvatars()
        var avatars: [AvatarContainer] = []
        
        avatarUrls?.forEach({ (url) in
            let fileName = url.lastPathComponent
            let name = fileName.sub(to: 4)
            let avatar = Avatar.init(name: name, isFave: false)
            let container = AvatarContainer.init(isSelected: false, avatar: avatar)
            avatars.append(container)
        })
        
        return avatars
    }
    
    func getAvatars() -> [URL]? {
        if let adorableGroup = self.adorableAvatarsGroupUrl, let groupContent = try? FileManager.default.contentsOfDirectory(at: adorableGroup, includingPropertiesForKeys: nil) {
            return groupContent
        }
        return nil
    }
}
