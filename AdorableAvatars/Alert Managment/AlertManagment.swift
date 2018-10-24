//
//  Error Managment.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 22/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class AlertManagment {

    
    /// make a alert to be showed when the user id deleting a avatar
    ///
    /// - Parameter sucess: a completion if the user confirms the deletion
    /// - Returns: the alert
    static public func alertRemoveAvatar(sucess: @escaping () -> ()) -> UIAlertController {
        let alertRemoveAvatar = UIAlertController.init(title: "Remove Avatar", message: "Do You Want Remove It? ", preferredStyle: .alert)
        alertRemoveAvatar.addAction(UIAlertAction.init(title: "Yes", style: .default, handler: { (action) in
            sucess()
        }))
        alertRemoveAvatar.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
        return alertRemoveAvatar
    }
    
    
    /// make a alert to be showerd when a error happens
    ///
    /// - Parameter description: the error description
    /// - Returns: the alert
    static public func genericErrorAlert(withDescription description: String) -> UIAlertController {
        let alertError = UIAlertController.init(title: "Error", message: description, preferredStyle: .actionSheet)
        
        alertError.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        
        return alertError
    }
    
    
    /// make a alert to be showed when a network error happens
    ///
    /// - Returns: the alert
    static public func networkErrorAlert(completion: @escaping () -> ()) -> UIAlertController {
        let alertError = UIAlertController.init(title: "Error", message: "Network Error", preferredStyle: .actionSheet)
        
        alertError.addAction(UIAlertAction.init(title: "Retry", style: .default, handler: { (alert) in
            completion()
        }))
        return alertError
    }
    
    
    /// make a alert to be showed when the user is saving a avatar, it shows a textfield
    ///
    /// - Parameter sucess: completion when the user finish to type
    /// - Returns: the alert
    static public func saveAvatarAlert(sucess: @escaping (_ name: String?) -> ()) -> UIAlertController {
        let alert = UIAlertController.init(title: "Saving", message: "Whats is him name? ", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            sucess(alert.textFields?.first?.text)
        }))
        
        alert.addTextField(configurationHandler: nil)
        
        return alert
    }
    
    
    /// a alert to me showed when a error happend when saving a avatar, when the avatar name already exists
    ///
    /// - Parameter name: name that is repeated
    /// - Returns: the alert
    static public func saveAvatarErrorAlert(name: String) -> UIAlertController{
        let alertError = UIAlertController.init(title: "Error", message: "Avatar With Name \"\(name)\" Already Exists", preferredStyle: .actionSheet)
        
        alertError.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        
        return alertError
    }
}
