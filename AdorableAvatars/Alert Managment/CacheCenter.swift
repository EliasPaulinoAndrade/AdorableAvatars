//
//  CacheCenter.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 29/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

public struct CacheCenter {
    static var shared = CacheCenter.init()
    
    private var imageCache: NSCache<NSString, UIImage> = NSCache.init()
    
    private init() { }
    
    func add(image: UIImage, withKey key: String) {
        imageCache.setObject(image, forKey: key as NSString)
    }
    
    func get(withKey key: String) -> UIImage? {
        return imageCache.object(forKey: key as NSString)
    }
}
