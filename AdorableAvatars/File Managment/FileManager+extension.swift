//
//  FileManager+avatarManager.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

extension FileManager {
    
    static let adorableAvatarsGroupNamePath = "group.eliaspaulino.adorableavatars"
    private static let avatarFolderName = "avatars"
    
    /// the shared group between the notification service extension and the main app targets
    public var adorableAvatarsGroupUrl : URL? {
        get {
            let adorableAvatarsGroupUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: FileManager.adorableAvatarsGroupNamePath)
            
            if let avatarsDirectory = adorableAvatarsGroupUrl?.appendingPathComponent(FileManager.avatarFolderName) {
                try? createDirectory(at: avatarsDirectory, withIntermediateDirectories: false, attributes: nil)
                return avatarsDirectory
            }
            return nil
        }
    }
    
    /// save a avatar image in the app group
    ///
    /// - Parameters:
    ///   - image: image to save
    ///   - name: image path name
    /// - Returns: the url where the image was placed in
    @discardableResult
    public func saveAvatarImage(_ image: UIImage, withName name: String) -> URL?{
        
        if let adorableGroup = self.adorableAvatarsGroupUrl {
            let imageURL = adorableGroup.appendingPNGImage(withName: name)
            
            try? image.write(to: imageURL)
            
            return imageURL
        }
        return nil
    }
    
    
    /// delete a avatar image from app group
    ///
    /// - Parameter name: the name of avatar image path
    public func deleteAvatarImage(withName name: String) {
        if let adorableGroup = self.adorableAvatarsGroupUrl {
            let imageURL = adorableGroup.appendingPNGImage(withName: name)
            try? FileManager.default.removeItem(at: imageURL)
        }
    }
    
    
    /// get a specific avatar image by name
    ///
    /// - Parameter name: the avatar image name
    /// - Returns: the image
    public func getAvatarImage(withName name: String) -> UIImage? {
        var avatar: UIImage?
        
        if let adorableGroup = self.adorableAvatarsGroupUrl {
            let imageURL = adorableGroup.appendingPNGImage(withName: name)
            
            if let avatarImage = try? UIImage.init(url: imageURL) {
                avatar = avatarImage
            }
        }
        
        return avatar
    }
    
    public func getAvatarURL(withName name: String) -> URL? {
        var avatarURL: URL?
        
        if let adorableGroup = self.adorableAvatarsGroupUrl {
            avatarURL = adorableGroup.appendingPNGImage(withName: name)
            
        }
        return avatarURL
    }
    
    
    /// get all avatars saved on the app group
    ///
    /// - Returns: the avatar images
    public func getAvatars() -> [UIImage] {
        var avatars: [UIImage] = []
        
        if let adorableGroup = self.adorableAvatarsGroupUrl, let groupContent = try? FileManager.default.contentsOfDirectory(at: adorableGroup, includingPropertiesForKeys: nil) {
            for contentUrl in groupContent {
                if let avatarImageOpt = try? UIImage.init(url: contentUrl), let avatarImage = avatarImageOpt {
                    avatars.append(avatarImage)
                }
            }
        }
        return avatars
    }
    
    public func deleteAllContentOfGroup() {
        guard let groupUrl = adorableAvatarsGroupUrl else {
            return
        }
        
        let urls: [URL]? = try? contentsOfDirectory(at: groupUrl, includingPropertiesForKeys: nil)
        
        guard let safeUrls = urls else {
            return
        }
        
        for url in safeUrls {
            try? removeItem(at: url)
        }
    }
    
    public func renameAvatarImage(fromName name: String, toName newName: String) {
        guard let oldFileURL = adorableAvatarsGroupUrl?.appendingPNGImage(withName: name),
              let newFileName = adorableAvatarsGroupUrl?.appendingPNGImage(withName: newName)
              else {
            return
        }
        
        try? moveItem(at: oldFileURL, to: newFileName)
    }
}
