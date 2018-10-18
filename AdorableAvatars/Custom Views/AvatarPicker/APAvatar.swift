//
//  Avatar.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

struct APAvatar {
    var eye: Int
    var nose: Int
    var month: Int
    
    public func value(for component: APAvatarComponents) -> Int{
        switch component {
        case .eye:
            return self.eye
        case .month:
            return self.month
        case .nose:
            return self.nose
        }
    }
}
