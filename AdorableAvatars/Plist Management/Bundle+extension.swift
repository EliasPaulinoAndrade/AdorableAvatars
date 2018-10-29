//
//   Bundle+extension.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 28/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation

extension Bundle {
    func path(forPlist plistName: String) -> String? {
        return path(forResource: plistName, ofType: "plist")
    }
}
