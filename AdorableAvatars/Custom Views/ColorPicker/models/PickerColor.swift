//
//  PickerColor.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 24/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class PickerColor: NSObject{
    var color: UIColor
    var isSelected: Bool
    
    init(color: UIColor) {
        self.color = color
        self.isSelected = false
    }
    
    func isBigger(thenColor otherColor: PickerColor) -> Bool {
        guard let selfHue = self.color.getHue(),
            let otherHue = otherColor.color.getHue() else {
            return false
        }
        
        if (selfHue.brightness + 1 - selfHue.saturation) > (otherHue.brightness + 1 - otherHue.saturation) {
            return true
        }
        return false
    }
}

