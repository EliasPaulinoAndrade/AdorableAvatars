//
//  ColorVariation.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 05/11/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

struct ColorVariation {
    private(set) var variations: [PickerColor]
    var mainColor: PickerColor
    
    init(mainColor: PickerColor, withNumberOfVariations numberOfVariations: Int) {
        self.mainColor = mainColor
        self.variations = ColorVariation.calculateVariations(forMainColor: mainColor, numberOfVariations: numberOfVariations)
    }
    
    static private func calculateVariations(forMainColor mainColor: PickerColor, numberOfVariations: Int) -> [PickerColor] {
        guard let colorHue = mainColor.color.getHue() else {
            return []
        }
        
        let colorVariationSize: CGFloat = CGFloat(0.9)/CGFloat(numberOfVariations)
        var currentSaturation: CGFloat = 0.1
        var currentBright: CGFloat = 0.9
        
        var variationColors: [PickerColor] = []
        
        (0..<numberOfVariations).forEach { (_) in
            let currentColor = UIColor.init(
                hue: colorHue.hue,
                saturation: currentSaturation,
                brightness: currentBright,
                alpha: colorHue.alpha
            )
            
            let pickerColor = PickerColor.init(color: currentColor)
            variationColors.append(pickerColor)
            
            currentSaturation += colorVariationSize
            currentBright -= colorVariationSize
        }
        
        return variationColors
    }
}
