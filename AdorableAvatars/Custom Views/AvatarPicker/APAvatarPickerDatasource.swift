//
//  AvatarPickerDatasource.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol APAvatarPickerDatasource {
    func numberOfTypes(picker: UIAvatarPicker, forComponent component: APAvatarComponents) -> Int
    func initialValue(picker: UIAvatarPicker, forComponent component: APAvatarComponents) -> Int
}
