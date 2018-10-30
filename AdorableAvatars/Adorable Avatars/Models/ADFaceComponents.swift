//
//  FaceComponents.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

struct ADFaceComponents {
    var eyes: [String]
    var noses: [String]
    var mouths: [String]
    
    var eyesNumbers: [Int] {
        return stringToNumbers(array: self.eyes, from: 4)
    }
    var noseNumbers: [Int] {
        return stringToNumbers(array: self.noses, from: 4)
    }
    var mouthsNumbers: [Int] {
        return stringToNumbers(array: self.mouths, from: 5)
    }
    
    func stringToNumbers(array: [String], from: Int) -> [Int] {
        var nums: [Int] = []
        for component in array {
            if let componentNum = Int(component.sub(from: from)) {
                nums.append(componentNum)
            }
        }
        return nums
    }
}

extension ADFaceComponents: Decodable {
    enum CodingKeys: String, CodingKey {
        case face
    }
    
    enum FaceCodingKeys: String, CodingKey {
        case eyes
        case noses = "nose"
        case mouths = "mouth"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: FaceCodingKeys.self, forKey: .face)
        
        self.eyes = try nestedContainer.decode([String].self, forKey: .eyes)
        self.noses = try nestedContainer.decode([String].self, forKey: .noses)
        self.mouths = try nestedContainer.decode([String].self, forKey: .mouths)
    }
}
