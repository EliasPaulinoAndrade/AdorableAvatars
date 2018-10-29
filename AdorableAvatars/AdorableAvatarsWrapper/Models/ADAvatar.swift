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
    var color: UIColor?
    
    var url: URL? {
        if let eye = eye, let nose = nose, let month = month, let color = color {
            return URL.init(string: "https://api.adorable.io/avatars/face/eyes\(eye)/nose\(nose)/mouth\(month)/\(color.hexa())")
        } else {
            return nil
        }
    }
    init() {
        
    }
    
    init(withEye eye: Int, withNose nose: Int, withMonth month: Int, andColor color: UIColor) {
        self.eye = eye
        self.nose = nose
        self.month = month
        self.color = color
    }
    
    init(withDictionary dict: [String: Any]) {
        self.eye = dict["eye"] as? Int
        self.nose = dict["nose"] as? Int
        self.month = dict["month"] as? Int
        self.color = UIColor.init(withDictionary: dict)
    }
}
