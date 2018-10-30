//
//  String+sub.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

extension String {
    func sub(from number: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: number)
        
        return String(self[index..<self.endIndex])
    }
    
    func sub(to number: Int) -> String {
        let index = self.index(self.endIndex, offsetBy: -number)
        
        return String(self[self.startIndex..<index])
    }
}
