//
//  Localizable.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 27/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation

protocol Localizable: RawRepresentable, CustomStringConvertible {
    var localizable: String { get }
    var comment: String { get }
}

extension Localizable where Self.RawValue == String {
    
    var localizable: String {
        return NSLocalizedString(self.rawValue ,comment: self.comment)
    }
    
    var description: String {
        return localizable
    }
    
    var comment: String {
        switch self {
        default:
            return "default"
        }
    }
}
