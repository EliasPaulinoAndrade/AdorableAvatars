//
// Copyright (c) WhatsApp Inc. and its affiliates.
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.
//

import UIKit

struct Interoperability {
    private static let DefaultBundleIdentifier: String = "WA.WAStickersThirdParty"
    private static let PasteboardExpirationSeconds: TimeInterval = 60
    private static let PasteboardStickerPackDataType: String = "net.whatsapp.third-party.sticker-pack"
    private static let WhatsAppURL: URL = URL(string: "whatsapp://stickerPack")!

    static var iOSAppStoreLink: String?
    static var AndroidStoreLink: String?

    static func send(json: [String: Any]) -> Bool {
        if let bundleIdentifier = Bundle.main.bundleIdentifier {
            if bundleIdentifier.contains(DefaultBundleIdentifier) {
                fatalError("Your bundle identifier must not include the default one.");
            }
        }

        let pasteboard: UIPasteboard = UIPasteboard.general

        var jsonWithAppStoreLink: [String: Any] = json
        jsonWithAppStoreLink["ios_app_store_link"] = iOSAppStoreLink
        jsonWithAppStoreLink["android_play_store_link"] = AndroidStoreLink

        guard let dataToSend = try? JSONSerialization.data(withJSONObject: jsonWithAppStoreLink, options: []) else {
            return false
        }
        if #available(iOS 10.0, *) {
            pasteboard.setItems([[PasteboardStickerPackDataType: dataToSend]], options: [UIPasteboardOption.localOnly: true, UIPasteboardOption.expirationDate: NSDate(timeIntervalSinceNow: PasteboardExpirationSeconds)])
        } else {
            pasteboard.addItems([[PasteboardStickerPackDataType: dataToSend]])
        }
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(URL(string: "whatsapp://")!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(WhatsAppURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(WhatsAppURL)
                }
            }
        }
        return true
    }

    static func copyImageToPasteboard(image: UIImage) {
        UIPasteboard.general.image = image
    }
}
