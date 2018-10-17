//
//  AvatarPickerDatasource.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol AvatarPickerDatasource {
    func numberOfTypes(picker: AvatarPicker, forComponent component: AvatarComponents) -> Int
    func initialValue(picker: AvatarPicker, forComponent component: AvatarComponents) -> Int
}
