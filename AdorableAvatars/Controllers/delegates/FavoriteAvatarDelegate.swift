//
//  FavoriteAvatarDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

@objc protocol FavoriteAvatarDelegate {
    @objc optional func avatarWasFavorite(avatar: Avatar)
    func avatarWasDesfavorite(avatar: Avatar)
}
