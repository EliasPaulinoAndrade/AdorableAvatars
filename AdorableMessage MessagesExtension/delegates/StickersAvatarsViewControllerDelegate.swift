//
//  StickersDelegate.swift
//  AdorableMessage MessagesExtension
//
//  Created by Elias Paulino on 28/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation

protocol StickersAvatarsViewControllerDelegate {
    func currentSection(_ controller: StickerAvatarsViewController) -> StickerAvatarsViewController.Section
    func avatarsToShow() -> [Avatar]
}
