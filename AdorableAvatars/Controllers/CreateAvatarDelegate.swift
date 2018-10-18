//
//  CreateAvatarDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol CreateAvatarDelegate {
    func avatarWasCreated(controller: CreateAvatarViewController, avatar: Avatar)
}
