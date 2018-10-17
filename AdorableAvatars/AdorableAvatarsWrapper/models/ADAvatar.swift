//
//  ADAvatar.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

struct ADAvatar {
    var eye: Int?
    var nose: Int?
    var month: Int?
    
    var url: URL? {
        if let eye = eye, let nose = nose, let month = month {
            
            
            return URL.init(string: "https://api.adorable.io/avatars/face/eyes\(eye)/nose\(nose)/mouth\(month)/8e8895")
        } else {
            return nil
        }
    }
}
