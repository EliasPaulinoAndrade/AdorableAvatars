//
//  AvatarSharedDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 19/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol AvatarPreviewDelegate {
    func avatarShared(_ avatar: Avatar, withImage image: UIImage)
    func avatarWasFavorite(_ avatar: Avatar)
    func avatarWasDesfavorite(_ avatar: Avatar)
}
