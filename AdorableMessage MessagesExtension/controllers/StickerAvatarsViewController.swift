//
//  AllAvatarsViewController.swift
//  AdorableMessage MessagesExtension
//
//  Created by Elias Paulino on 28/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit
import Messages

class StickerAvatarsViewController: MSStickerBrowserViewController {
    
    static var delegate: StickersAvatarsViewControllerDelegate?
    
    weak var warningLabel: UILabel!

    private var stickers: [MSSticker] = {
        return loadStickers()
    }()
    
    static func loadStickers() -> [MSSticker]{
        guard let avatars = delegate?.avatarsToShow() else {
            return []
        }
        
        var stickers: [MSSticker] = []
        for avatar in avatars {
            if let avatarName = avatar.name {
                let avatarURL: URL? = FileManager.default.getAvatarURL(withName: avatarName)
                if  let safeAvatarURL = avatarURL,
                    let sticker = try? MSSticker.init(contentsOfFileURL: safeAvatarURL, localizedDescription: "") {
                    stickers.append(sticker)
                }
            }
        }
        return stickers
    }
    
    func setupWarningLabel() {
        if self.stickers.count == 0 {
            if StickerAvatarsViewController.delegate?.currentSection(self) == .all {
                self.warningLabel.text = "\(Strings.controller_allavatars_no_avatar_warning)"
            } else {
                self.warningLabel.text = "\(Strings.controller_favAvatars_no_avatar_warning)"
            }
            self.warningLabel.alpha = 1
        } else {
            self.warningLabel.alpha = 0
        }
    }
    
    func reloadStickers() {
        self.stickers = StickerAvatarsViewController.loadStickers()
        self.stickerBrowserView.reloadData()
    }

    func changeBackground(){
        stickerBrowserView.backgroundColor = UIColor.clear
    }
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        setupWarningLabel()
        return self.stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        return self.stickers[index]
    }
}

extension StickerAvatarsViewController {
    enum Strings: String, Localizable {
        case controller_allavatars_no_avatar_warning,
             controller_favAvatars_no_avatar_warning
    }
}

extension StickerAvatarsViewController {
    enum Section {
        case favorites, all
    }
}
