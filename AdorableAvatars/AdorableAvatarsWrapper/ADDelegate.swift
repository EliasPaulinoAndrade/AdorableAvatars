//
//  AdorableAvatarsDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol ADDelegate {
    func didLoadAvatarTypes(wrapper: ADWrapper)
    func didLoadAvatarImage(wrapper: ADWrapper, image: UIImage)
    func avatarLoadDidFail(wrapper: ADWrapper, for avatar: ADAvatar)
    func avatarTypesLoadDidFail(wrapper: ADWrapper)
}
