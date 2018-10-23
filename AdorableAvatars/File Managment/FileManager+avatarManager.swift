//
//  FileManager+avatarManager.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

extension FileManager {
    @discardableResult
    public func saveAvatarImage(_ image: UIImage, withName name: String) -> URL?{
        if let documentsURL = try? self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            
            let imageURL = documentsURL.appendingPathComponent("\(name).png")
            
            try? image.write(to: imageURL)
            
            return imageURL
        }
        return nil
    }
    @discardableResult
    public func saveTemporaryAvatarImage(image: UIImage) -> URL? {
        let tempDirectory = NSTemporaryDirectory()
        
        let tmpFile = "file://".appending(tempDirectory).appending("notification_image.png")
        guard let tempURL = URL(string: tmpFile) else {
            return nil
        }
        
        try? image.write(to: tempURL)
        
        return tempURL
    }
    
    public func deleteAvatarImage(withName name: String) {
        if let documentsURL = try? self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            
            let imageURL = documentsURL.appendingPathComponent("\(name).png")
            try? FileManager.default.removeItem(at: imageURL)
            
        }
    }
    
    public func getAvatar(withName name: String) -> UIImage? {
        var avatar: UIImage?
        
        if let documentsURL = try? self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false){
            
            let imageURL = documentsURL.appendingPathComponent("\(name).png")
            
            if let avatarImage = try? UIImage.init(url: imageURL) {
                avatar = avatarImage
            }
        }
        
        return avatar
    }
    
    public func getAvatars() -> [UIImage] {
        
        var avatars: [UIImage] = []
        
        if let documentsURL = try? self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
           let documentsContent = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) {
            
            for contentUrl in documentsContent {
                if let avatarImageOpt = try? UIImage.init(url: contentUrl), let avatarImage = avatarImageOpt {
                    avatars.append(avatarImage)
                }
            }
        }
        return avatars
    }
}
