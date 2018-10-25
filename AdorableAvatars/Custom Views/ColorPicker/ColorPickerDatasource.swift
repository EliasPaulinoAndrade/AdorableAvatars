//
//  ColorPickerDatasource.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol ColorPickerDatasource {
    func imageForSelectColor(colorPicker: ColorPicker) -> UIImage?
    func initialColor(colorPicker: ColorPicker) -> Int
    func colorForPosition(colorPicker: ColorPicker, position: Int) -> PickerColor?
    func numberOfColors(colorPicker: ColorPicker) -> Int
    func sizeForColorViews(colorPicker: ColorPicker) -> CGSize
}
