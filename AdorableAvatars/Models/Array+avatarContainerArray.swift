//
//  Array+avatarContainerArray.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 24/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation

extension Array where Element: Avatar {
    func avatarContainerArray() -> [AvatarContainer] {
        var avatarContainerArray: [AvatarContainer] = []
        for avatar in self {
            let avatarContainer = AvatarContainer.init(isSelected: false, avatar: avatar)
            avatarContainerArray.append(avatarContainer)
        }
        
        return avatarContainerArray
    }
}

extension Array where Element == AvatarContainer {
    func firstIndex(of avatar: Avatar) -> Int? {
        var position = 0
        for avatarContainer in self {
            if avatarContainer.avatar.objectID == avatar.objectID {
                return position
            }
            position += 1
        }
        return nil
    }
}
