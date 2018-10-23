//
//  UIImage+URL.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 23/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

public extension UIImage {
    convenience public init?(url: URL) throws {
        let data = try Data.init(contentsOf: url)
        self.init(data: data)
    }
    public func write(to url: URL) throws {
        let data = self.pngData()
        try data?.write(to: url)
    }
}
