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
    
    static var delegate: StickersDelegate?

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
                let avatarURL: URL? = FileManager.default.getAvatar(withName: avatarName)
                if  let safeAvatarURL = avatarURL,
                    let sticker = try? MSSticker.init(contentsOfFileURL: safeAvatarURL, localizedDescription: "") {
                    stickers.append(sticker)
                }
            }
        }
        return stickers
    }
    
    func reloadStickers() {
        self.stickers = StickerAvatarsViewController.loadStickers()
        self.stickerBrowserView.reloadData()
    }

    func changeBackground(){
        stickerBrowserView.backgroundColor = UIColor.clear
    }
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return self.stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        return self.stickers[index]
    }
}
