//
//  PlistReader.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

struct PlistReader {
    private static let avatarsColorsPlistName = "avatarColors"
    /// the colors in the avatarColors plist
    var colors: [UIColor] = {
        var colors:[UIColor] = []
        if let path = Bundle.main.path(forPlist: PlistReader.avatarsColorsPlistName),
           let colorsArray = NSArray.init(contentsOfFile: path) as? [[String]]{
            for colorRGB in colorsArray {
                let color = UIColor.init(withArray: colorRGB)
                colors.append(color)
            }
        }
        return colors
    }()
}
