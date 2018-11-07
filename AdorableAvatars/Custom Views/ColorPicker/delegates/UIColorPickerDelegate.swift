//
//  ColorPickerDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol UIColorPickerDelegate {
    func mainColorWasSelected(_ colorPicker: UIColorPicker, atPosition position: Int)
    func variationColorWasSelected(_ colorPicker: UIColorPicker, atPosition: Int, variation: UIColor)
    func responsibleController(_ colorPicker: UIColorPicker) -> UIViewController
    func numberOfVariationsPerColor(_ colorPicker: UIColorPicker) -> Int
}
