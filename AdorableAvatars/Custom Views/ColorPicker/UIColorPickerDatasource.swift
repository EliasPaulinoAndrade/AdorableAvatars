//
//  ColorPickerDatasource.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol UIColorPickerDatasource {
    func imageForSelectColor(colorPicker: UIColorPicker) -> UIImage?
    func initialColor(colorPicker: UIColorPicker) -> Int
    func colorForPosition(colorPicker: UIColorPicker, position: Int) -> PickerColor?
    func numberOfColors(colorPicker: UIColorPicker) -> Int
    func sizeForColorViews(colorPicker: UIColorPicker) -> CGSize
}
