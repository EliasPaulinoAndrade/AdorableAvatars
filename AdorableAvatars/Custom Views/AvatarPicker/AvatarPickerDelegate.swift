//
//  AvatarPickerDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation

protocol AvatarPickerDelegate {
    func nextTapped(_ picker: AvatarPicker, inPart avatarComponent: AvatarComponents, toNumber number: Int)
    func prevTapped(_ picker: AvatarPicker, inPart avatarComponentß: AvatarComponents, toNumber number: Int)
}
