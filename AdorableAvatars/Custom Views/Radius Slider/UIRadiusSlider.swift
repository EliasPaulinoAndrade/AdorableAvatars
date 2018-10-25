//
//  UIRadiusSlider.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 25/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class UIRadiusSlider: UISlider {

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = 8
        return newBounds
    }
}
