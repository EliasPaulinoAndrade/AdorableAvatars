//
//  FileManager+avatarManager.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

extension FileManager {
    public func saveAvatar(_ image: UIImage, withName name: String) {
        if let data = image.pngData(),
           let documentsURL = try? self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false){
            
            let imageURL = documentsURL.appendingPathComponent("\(name).png")
            
            try? data.write(to: imageURL)
        }
    }
    
    public func getAvatars() -> [UIImage] {
        
        var avatars: [UIImage] = []
        print("ph")
        
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
