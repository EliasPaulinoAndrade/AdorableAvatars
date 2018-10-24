//
//  Array+PickerColor.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 24/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element:UIColor {
    func pickerColorArray() -> [PickerColor]{
        var pickerColorArray: [PickerColor] = []
        for color in self {
            let pickerColor = PickerColor.init(color: color)
            pickerColorArray.append(pickerColor)
            
        }
        return pickerColorArray
    }
}
