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
        if let data = image.pngData(),
           let documentsURL = try? self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            
            let imageURL = documentsURL.appendingPathComponent("\(name).png")
            
            try? data.write(to: imageURL)
            
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
        guard let imageData = image.pngData() else {
            return nil
        }
        
        try? imageData.write(to: tempURL)
        
        return tempURL
    }
    
    public func deleteAvatarImage(withName name: String) {
        if let documentsURL = try? self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            
            print(getAvatars().count)
            
            let imageURL = documentsURL.appendingPathComponent("\(name).png")
            try? FileManager.default.removeItem(at: imageURL)
            
            print(getAvatars().count)
        }
    }
    
    public func getAvatar(withName name: String) -> UIImage? {
        var avatar: UIImage?
        
        if let documentsURL = try? self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false){
            
            let imageURL = documentsURL.appendingPathComponent("\(name).png")
            if let imageData = try? Data.init(contentsOf: imageURL){
                avatar = UIImage.init(data: imageData)
            }
        }
        
        return avatar
    }
    
    public func getAvatars() -> [UIImage] {
        
        var avatars: [UIImage] = []
        
        if let documentsURL = try? self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false),
           let documentsContent = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) {
            
            for contentUrl in documentsContent {
                
                if let data = try? Data.init(contentsOf: contentUrl), let avatar = UIImage.init(data: data) {
                    avatars.append(avatar)
                }
            }
        }
        return avatars
    }
}
