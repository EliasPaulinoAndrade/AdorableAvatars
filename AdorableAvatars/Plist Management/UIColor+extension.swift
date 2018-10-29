

//
//  UIColor.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 24/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience public init(withArray rgbArray: [String]) {
        let rPart = CGFloat(Double(rgbArray[0]) ?? 0) / 255
        let gPart = CGFloat(Double(rgbArray[1]) ?? 0) / 255
        let bPart = CGFloat(Double(rgbArray[2]) ?? 0) / 255
        
        self.init(red: rPart, green: gPart, blue: bPart, alpha: 1)
    }
    convenience public init(withDictionary rgbDict: [String: Any]){
        let rPart = (rgbDict["colorR"] as? CGFloat ?? 255)/255
        let gPart = (rgbDict["colorG"] as? CGFloat ?? 255)/255
        let bPart = (rgbDict["colorB"] as? CGFloat ?? 255)/255
        self.init(red: rPart, green: gPart, blue: bPart, alpha: 1)
    }
}
