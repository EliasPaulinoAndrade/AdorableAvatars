//
//  WhatsAppService.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 04/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import Foundation

class WhatsAppService {
    let stickerDefaultSize = CGSize.init(width: 512, height: 512)
    let stickerPack: StickerPack? = try? StickerPack(identifier: "paulino.elias.AdorableAvatars",
                                      name: "Adorable Avatars",
                                      publisher: "Elias Paulino",
                                      trayImageFileName: "tray_adorable.png",
                                      publisherWebsite: "https://github.com/EliasPaulinoAndrade",
                                      privacyPolicyWebsite: nil,
                                      licenseAgreementWebsite: nil)
    
    func sendStickers(fromAvatars avatars: [Avatar]) throws {
        
        for avatar in avatars {
            if let avatarName = avatar.name,
               let avatarImage = FileManager.default.getAvatarImage(withName: avatarName),
               let resizedAvatarImage = avatarImage.resized(toSize: self.stickerDefaultSize),
               let resizedAvatarImageData = resizedAvatarImage.pngData() {
                
                try stickerPack?.addSticker(imageData: resizedAvatarImageData, type: .png, emojis: nil)
            }
        }
        
        stickerPack?.sendToWhatsApp(completionHandler: { (flag) in
            print(flag)
        })
    }
}
