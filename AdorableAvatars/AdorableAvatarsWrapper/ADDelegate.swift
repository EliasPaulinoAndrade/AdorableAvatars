//
//  AdorableAvatarsDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol ADDelegate {
    
}

protocol ADAvatarDelegate:ADDelegate {
    func didLoadAvatarImage(wrapper: ADWrapper, image: UIImage)
    func avatarLoadDidFail(wrapper: ADWrapper, for avatar: ADAvatar)
}

protocol ADTypesDelegate:ADDelegate {
    func didLoadAvatarTypes(wrapper: ADWrapper)
    func avatarTypesLoadDidFail(wrapper: ADWrapper)
}

protocol ADRandomAvatarDelegate:ADDelegate {
    func randomAvatarDidFail(wrapper: ADWrapper, forNumber number: Int)
    func didLoadRandomAvatar(wrapper: ADWrapper, forNumber number: Int, image: UIImage)
}
