//
//  UIView+position.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 25/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func isStanding() -> Bool{
        if self.frame.width < self.frame.height {
            return true
        }
        return false
    }
}
