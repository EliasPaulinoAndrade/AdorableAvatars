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
            return URL.init(string: "https://api.adorable.io/avatars/face/eyes\(eye)/nose\(nose)/mouth\(month)/\(color.hexa())/250")
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
    
    func nextStates(wrapper: ADWrapper) -> [ADAvatar?] {
        
        return [self.addingEye(wrapper: wrapper), self.addingNose(wrapper: wrapper), self.addingMonth(wrapper: wrapper)]
    }
    
    func addingNose(wrapper: ADWrapper) -> ADAvatar? {
        var addingNoseAvatar = self
        guard   let currentNose = addingNoseAvatar.nose,
                let noses = wrapper.components?.noseNumbers,
                let indexOfCurrentNose = noses.firstIndex(of: currentNose)
                else {
            return nil
        }
        let indexOfNextNose = indexOfCurrentNose + 1
        if indexOfNextNose < noses.count {
            addingNoseAvatar.nose = noses[indexOfNextNose]
            return addingNoseAvatar
        }
        return nil
    }
    
    func addingMonth(wrapper: ADWrapper) -> ADAvatar? {
        var addingMonthAvatar = self
        guard   let currentMonth = addingMonthAvatar.month,
                let months = wrapper.components?.mouthsNumbers,
                let indexOfCurrentMonth = months.firstIndex(of: currentMonth)
            else {
                return nil
        }
        
        let indexOfNextMonth = indexOfCurrentMonth + 1
        if indexOfNextMonth < months.count {
            addingMonthAvatar.month = months[indexOfNextMonth]
            return addingMonthAvatar
        }
        return nil
    }
    
    func addingEye(wrapper: ADWrapper) -> ADAvatar? {
        var addingEyeAvatar = self
        guard   let currentEye = addingEyeAvatar.eye,
                let eyes = wrapper.components?.eyesNumbers,
                let indexOfCurrentEye = eyes.firstIndex(of: currentEye)
            else {
                return nil
        }
       
        let indexOfNextEye = indexOfCurrentEye + 1
        if indexOfNextEye < eyes.count {
            addingEyeAvatar.eye = eyes[indexOfNextEye]
            return addingEyeAvatar
        }
        return nil
    }
}
