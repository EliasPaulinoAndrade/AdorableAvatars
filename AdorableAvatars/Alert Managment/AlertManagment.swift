//
//  Error Managment.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 22/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class AlertManagment {

    static public func alertRemoveAvatar(sucess: @escaping () -> ()) -> UIAlertController {
        let alertRemoveAvatar = UIAlertController.init(title: "Remove Avatar", message: "Do You Want Remove It? ", preferredStyle: .alert)
        alertRemoveAvatar.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (action) in
            sucess()
        }))
        alertRemoveAvatar.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
        return alertRemoveAvatar
    }
    
    static public func genericErrorAlert(withDescription description: String) -> UIAlertController {
        let alertError = UIAlertController.init(title: "Error", message: description, preferredStyle: .actionSheet)
        
        alertError.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        
        return alertError
    }
    
    static public func networkErrorAlert() -> UIAlertController {
        let alertError = UIAlertController.init(title: "Error", message: "Network Error", preferredStyle: .actionSheet)
        
        alertError.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        
        return alertError
    }
}
