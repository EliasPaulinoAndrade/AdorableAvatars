//
//  UIImage+URL.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 23/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// fetch a image from url
    ///
    /// - Parameter url: the url of the target image
    /// - Throws: data conversion error
    convenience public init?(url: URL) throws {
        let data = try Data.init(contentsOf: url)
        self.init(data: data)
    }
    
    
    /// save a image to app group
    ///
    /// - Parameter url: the url to save image
    /// - Throws: data write error
    func write(to url: URL) throws {
        let data = self.pngData()
        try data?.write(to: url)
    }
}
