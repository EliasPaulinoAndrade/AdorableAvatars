//
//  UserDefaults+extension.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 03/11/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation

extension UserDefaults {
    public static var adorableAvatarsStandard: UserDefaults = UserDefaults.init(suiteName: FileManager.adorableAvatarsGroupNamePath) ?? UserDefaults.standard
}
