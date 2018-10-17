//
//  String+sub.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

extension String {
    func sub(from: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: from)
        
        return String(self[index..<self.endIndex])
    }
}
