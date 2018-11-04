//
//  UIColor+saturation.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 03/11/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func getHue() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)? {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var bright: CGFloat = 0
        var alpha: CGFloat = 0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &bright, alpha: &alpha){
            return (hue, saturation, bright, alpha)
        }
        
        return nil
    }
}
