//
//  FileManager+avatarArray.swift
//  AdorableMessage MessagesExtension
//
//  Created by Elias Paulino on 26/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension FileManager {
    func saveRandomSticker(image: UIImage) -> URL? {
        guard let randomFolderURL = adorableAvatarsGroupUrl?.appendingPathComponent("random") else {
            return nil
        }
        try? createDirectory(at: randomFolderURL, withIntermediateDirectories: false, attributes: nil)
        
        let url = randomFolderURL.appendingPathComponent("random_sticker.png")
        do{
            try image.write(to: url)
            return url
        } catch {
            return nil
        }
    }
}
