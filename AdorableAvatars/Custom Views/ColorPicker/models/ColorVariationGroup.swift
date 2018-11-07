//
//  ColorVariation.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 05/11/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

struct ColorVariationGroup {
    typealias This = ColorVariationGroup
    
    static var colorMargin: CGFloat = 0.3
    static let saturationAndBrightMaxValue: CGFloat = 1
    
    var variationsIncludingMainColor: [PickerColor] {
        var variationsIncludingMainColor =  Array(variations[0..<mainColorPosition])
        variationsIncludingMainColor += [mainColor]
        variationsIncludingMainColor += Array(self.variations[mainColorPosition..<variations.count])
        
        return variationsIncludingMainColor
    }
    
    var selectedVariationIncludingMainColor: Int? {
        guard let selectedVariation = self.selectedVariation else {
            return nil
        }
        if selectedVariation < mainColorPosition {
            return selectedVariation
        }
        return selectedVariation + 1
    }
    
    private(set) var variations: [PickerColor]
    var mainColor: PickerColor
    var mainColorPosition: Int
    var selectedVariation: Int?
    
    init(mainColor: PickerColor, withNumberOfVariations numberOfVariations: Int) {
        self.mainColor = mainColor
        (self.variations, self.mainColorPosition) = This.calculateVariations(forMainColor: mainColor, numberOfVariations: numberOfVariations)
    }
    
    static private func calculateVariations(forMainColor mainColor: PickerColor, numberOfVariations: Int) -> (variations: [PickerColor], mainColorPosition: Int) {
        var mainColorPosition = 0

        guard let colorHue = mainColor.color.getHue() else {
            return ([], mainColorPosition)
        }
        
        let colorVariationSize: CGFloat = CGFloat(saturationAndBrightMaxValue - 2*colorMargin)/CGFloat(numberOfVariations)
        var currentSaturation: CGFloat = This.colorMargin
        var currentBright: CGFloat = This.saturationAndBrightMaxValue - This.colorMargin
        
        return ((0..<numberOfVariations).map { (variationIndex) -> PickerColor in
            let currentPickerColor = PickerColor(color: UIColor(
                hue: colorHue.hue,
                saturation: currentSaturation,
                brightness: currentBright,
                alpha: colorHue.alpha
            ))
            
            currentSaturation += colorVariationSize
            currentBright -= colorVariationSize
            
            if mainColor.isBigger(thenColor: currentPickerColor) {
                mainColorPosition = variationIndex
            }
            
            return currentPickerColor
        }, mainColorPosition)
    }
}
