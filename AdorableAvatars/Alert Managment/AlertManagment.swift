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
    
    static public func alertSendAsSticker(sucess: @escaping () -> ()) -> UIAlertController {
        let alertSendAsSticker = UIAlertController.init(
            title: "Sending",
            message: Strings.send_stickers_alert_title.localizable,
            preferredStyle: .alert
        )
        
        alertSendAsSticker.addAction(UIAlertAction.init(
            title: Strings.send_stickers_alert_title_yes.localizable,
            style: .default,
            handler: { (action) in
                sucess()
        }
        ))
        
        alertSendAsSticker.addAction(UIAlertAction.init(
            title: Strings.send_stickers_alert_title_no.localizable,
            style: .cancel,
            handler: nil
        ))
        
        return alertSendAsSticker
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
    
    static public func networkErrorWithCancelAlert(completion: @escaping (_ sucess: Bool) -> ()) -> UIAlertController {
        
        let alertError = UIAlertController.init(
            title: Strings.alert_network_error_with_cancel_title.localizable,
            message: Strings.alert_network_with_cancel_description.localizable,
            preferredStyle: .actionSheet
        )
        
        alertError.addAction(UIAlertAction.init(
            title: Strings.alert_network_with_cancel_description_action_retry.localizable,
            style: .default,
            handler: { (alert) in
                completion(true)
            }
        ))
        
        alertError.addAction(UIAlertAction.init(
            title: Strings.alert_network_with_cancel_description_action_cancel.localizable,
            style: .cancel,
            handler: { (alert) in
                completion(false)
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
    
    static public func openAdorableAppAlert(sucess: @escaping () -> ()) -> UIAlertController{
        let alert = UIAlertController.init(
            title: Strings.controller_messases_open_adorable_app_title.localizable,
            message: Strings.controller_messases_open_adorable_app.localizable,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction.init(
            title: Strings.controller_messases_open_adorable_actio_no.localizable,
            style: .cancel,
            handler: nil
        ))
        
        alert.addAction(UIAlertAction.init(
            title: Strings.controller_messases_open_adorable_actio_yes.localizable,
            style: .default,
            handler: { (action) in
                sucess()
            }
        ))
        return alert
    }
    
    static public func avatarOptionsAlert(avatarName: String, share: @escaping () -> (), rename: @escaping (_ newName: String) -> (), image: UIImage, isFave: Bool, context: UIViewController) -> UIAlertController{
        let alert = UIAlertController.init(title: "Avatar Options", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction.init(
            title: "\(Strings.controller_preview_var_previewActionItems_share_action_title)",
            style: .default,
            handler: { (action) in
                share()
            }
        ))
        
        alert.addAction(UIAlertAction.init(
            title: "Rename Avatar",
            style: .default,
            handler: { (action) in
                context.present(AlertManagment.renameAvatarAlert(withName: avatarName, sucess: { (name) in
                    if let newName = name {
                        rename(newName)
                    }
                }), animated: true, completion: nil)
            }
        ))
        
        alert.addAction(UIAlertAction.init(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        
        return alert
    }
    
    static public func renameAvatarAlert(withName name: String, sucess: @escaping (_ name: String?) -> ()) -> UIAlertController {
        let alert = UIAlertController.init(
            title: "Renaming",
            message: "What is The New Name of \(name)?",
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
        case
                controller_messases_open_adorable_app,
                controller_messases_open_adorable_actio_yes,
                controller_messases_open_adorable_actio_no,
                controller_messases_open_adorable_app_title
        case
                alert_network_error_with_cancel_title,
                alert_network_with_cancel_description,
                alert_network_with_cancel_description_action_retry,
                alert_network_with_cancel_description_action_cancel
        
        case    controller_preview_var_previewActionItems_share_action_title,
                controller_preview_var_previewActionItems_fave_action_title,
                controller_preview_var_previewActionItems_unfave_action_title
        
        case    send_stickers_alert_title,
                send_stickers_alert_title_yes,
                send_stickers_alert_title_no
        
        var comment: String {
            switch self {
            default:
                return "default"
            }
        }
    }
}
