//
//  Error Managment.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 22/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol LocalizableAlerts {
    associatedtype Strings: Localizable
}

class AlertManagment {

    
    /// make a alert to be showed when the user id deleting a avatar
    ///
    /// - Parameter sucess: a completion if the user confirms the deletion
    /// - Returns: the alert
    static public func alertRemoveAvatar(sucess: @escaping () -> ()) -> UIAlertController {
        let alertRemoveAvatar = UIAlertController.init(
            title: Strings.alert_remove_avatar_title.localizable,
            message: Strings.alert_remove_avatar_description.localizable,
            preferredStyle: .alert
        )
        
        alertRemoveAvatar.addAction(UIAlertAction.init(
            title: Strings.alert_remove_avatar_action_yes.localizable,
            style: .default,
            handler: { (action) in
                sucess()
            }
        ))
        
        alertRemoveAvatar.addAction(UIAlertAction.init(
            title: Strings.alert_remove_avatar_action_no.localizable,
            style: .cancel,
            handler: nil
        ))
        return alertRemoveAvatar
    }
    
    
    /// make a alert to be showerd when a error happens
    ///
    /// - Parameter description: the error description
    /// - Returns: the alert
    static public func genericErrorAlert(withDescription description: String) -> UIAlertController {
        let alertError = UIAlertController.init(
            title: Strings.alert_generic_error_title.localizable,
            message: description,
            preferredStyle: .actionSheet
        )
        
        alertError.addAction(UIAlertAction.init(
            title: Strings.alert_generic_error_action_ok.localizable,
            style: .cancel,
            handler: nil
        ))
        
        return alertError
    }
    
    
    /// make a alert to be showed when a network error happens
    ///
    /// - Returns: the alert
    static public func networkErrorAlert(completion: @escaping () -> ()) -> UIAlertController {
        let alertError = UIAlertController.init(
            title: Strings.alert_network_error_title.localizable,
            message: Strings.alert_network_description.localizable,
            preferredStyle: .actionSheet
        )
        
        alertError.addAction(UIAlertAction.init(
            title: Strings.alert_network_description_action_retry.localizable,
            style: .default,
            handler: { (alert) in
                completion()
            }
        ))
        return alertError
    }
    
    
    /// make a alert to be showed when the user is saving a avatar, it shows a textfield
    ///
    /// - Parameter sucess: completion when the user finish to type
    /// - Returns: the alert
    static public func saveAvatarAlert(sucess: @escaping (_ name: String?) -> ()) -> UIAlertController {
        let alert = UIAlertController.init(
            title: Strings.alert_save_avatar_title.localizable,
            message: Strings.alert_save_avatar_description.localizable,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction.init(
            title: Strings.alert_save_avatar_action_cancel.localizable,
            style: .cancel,
            handler: nil
        ))
        
        alert.addAction(UIAlertAction.init(
            title: Strings.alert_save_avatar_action_ok.localizable,
            style: .default,
            handler: { (action) in
                sucess(alert.textFields?.first?.text)
            }
        ))
        
        alert.addTextField(configurationHandler: nil)
        
        return alert
    }
    
    
    /// a alert to me showed when a error happend when saving a avatar, when the avatar name already exists
    ///
    /// - Parameter name: name that is repeated
    /// - Returns: the alert
    static public func saveAvatarErrorAlert(name: String) -> UIAlertController{
        let alertError = UIAlertController.init(
            title: Strings.alert_save_avatar_error_title.localizable,
            message: "\(Strings.alert_save_avatar_error_description_sufix.localizable) \"\(name)\" \(Strings.alert_save_avatar_error_description_sufix.localizable)",
            preferredStyle: .actionSheet
        )
        
        alertError.addAction(UIAlertAction.init(
            title: Strings.alert_save_avatar_error_action_ok.localizable,
            style: .cancel,
            handler: nil
        ))
        
        return alertError
    }
    
    static public func sendAvatarAlert(answered: @escaping (_ include: Bool) -> ()) -> UIAlertController {
        let alert = UIAlertController.init(
            title: Strings.alert_send_avatar_title.localizable,
            message: Strings.alert_send_avatar_description.localizable,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction.init(
            title: Strings.alert_send_avatar_action_no.localizable,
            style: .cancel,
            handler: { (action) in
                answered(false)
            }
        ))
        
        alert.addAction(UIAlertAction.init(
            title: Strings.alert_send_avatar_action_yes.localizable,
            style: .default,
            handler: { (action) in
                answered(true)
            }
        ))
        
        return alert
    }
}

extension AlertManagment: LocalizableAlerts {
    enum Strings: String, Localizable {
        case    alert_remove_avatar_title,
                alert_remove_avatar_description,
                alert_remove_avatar_action_yes,
                alert_remove_avatar_action_no
        case
                alert_generic_error_title,
                alert_generic_error_action_ok
        case
                alert_network_error_title,
                alert_network_description,
                alert_network_description_action_retry
        case
                alert_save_avatar_title,
                alert_save_avatar_description,
                alert_save_avatar_action_cancel,
                alert_save_avatar_action_ok,
                alert_save_avatar_error_title,
                alert_save_avatar_error_description_prefix,
                alert_save_avatar_error_description_sufix,
                alert_save_avatar_error_action_ok
        case
                alert_send_avatar_title,
                alert_send_avatar_description,
                alert_send_avatar_action_yes,
                alert_send_avatar_action_no
        
        var comment: String {
            switch self {
            default:
                return "default"
            }
        }
    }
}
