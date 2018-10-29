//
//  URL+extension.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 28/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation

extension URL {
    
    func appendingPNGImage(withName name: String) -> URL {
        return self.appendingPathComponent("\(name).png")
    }
}
