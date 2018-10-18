//
//  AvatarPickerDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation

protocol APAvatarPickerDelegate {
    func nextTapped(_ picker: UIAvatarPicker, inPart avatarComponent: APAvatarComponents, toNumber number: Int)
    func prevTapped(_ picker: UIAvatarPicker, inPart avatarComponentß: APAvatarComponents, toNumber number: Int)
}
