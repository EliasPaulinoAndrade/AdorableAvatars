//
//  AvatarSharedDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 19/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

@objc
protocol AvatarPreviewDelegate {
    @objc optional func avatarShared(_ avatar: Avatar, withImage image: UIImage)
    @objc optional func avatarWasFavorite(_ avatar: Avatar)
    func avatarWasDesfavorite(_ avatar: Avatar)
}
