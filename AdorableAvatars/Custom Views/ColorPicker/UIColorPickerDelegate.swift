//
//  ColorPickerDelegate.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol UIColorPickerDelegate {
    func colorWasSelected(_ colorPicker: UIColorPicker, atPosition position: Int)
}
