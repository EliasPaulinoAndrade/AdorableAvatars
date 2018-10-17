//
//  PlistReader.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

struct PlistReader {
    var colors: [UIColor] = {
        var colors:[UIColor] = []
        if let path = Bundle.main.path(forResource: "avatarColors", ofType: "plist"),
           let colorsArray = NSArray.init(contentsOfFile: path) as? [[String]]{
            for colorRGB in colorsArray {
                let rPart = CGFloat(Double(colorRGB[0]) ?? 0) / 255
                let gPart = CGFloat(Double(colorRGB[1]) ?? 0) / 255
                let bPart = CGFloat(Double(colorRGB[2]) ?? 0) / 255
                
                let color = UIColor.init(red: rPart, green: gPart, blue: bPart, alpha: 1)
                colors.append(color)
            }
        }
        return colors
    }()
}
