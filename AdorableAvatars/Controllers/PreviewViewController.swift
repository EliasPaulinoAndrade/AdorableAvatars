//
//  PreviewViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit


struct PreviewViewControllerReceivedData: UIViewControllerInputData {
    let image: UIImage?
    let avatar: Avatar?
}

class PreviewViewController: UICommunicableViewController {
    @IBOutlet weak var previewImageView: UIImageView!
    
    public var delegate: AvatarPreviewDelegate?
    
    private var avatar: Avatar?
    
    lazy override var previewActionItems: [UIPreviewActionItem] = {
        guard let avatar = self.avatar else {
            return []
        }
        
        let shareAction = UIPreviewAction.init(
            title: "\(Strings.controller_preview_var_previewActionItems_share_action_title)",
            style: .default) { (action, controller) in
            if let image = self.previewImageView.image {
                self.delegate?.avatarShared?(avatar, withImage: image)
            }
        }
    
        let faveAction = UIPreviewAction.init(
            title: avatar.isFave ? "\(Strings.controller_preview_var_previewActionItems_unfave_action_title)" : "\(Strings.controller_preview_var_previewActionItems_fave_action_title)",
            style: .default) { (action, controller) in
            if avatar.isFave {
                self.delegate?.avatarWasDesfavorite(avatar)
            } else {
                self.delegate?.avatarWasFavorite?(avatar)
            }
        }
        
        return [shareAction, faveAction]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.previewActionItems = []
        
    }
    
    override func orderReceived(action: UIViewControllerAction?, receivedData: UIViewControllerInputData?) {
        guard let safeData = receivedData as? PreviewViewControllerReceivedData else {
            return
        }
        
        self.previewImageView.image = safeData.image
        self.avatar = safeData.avatar
    }
}

extension PreviewViewController {
    
    enum Strings: String, Localizable {
        case    controller_preview_var_previewActionItems_share_action_title,
                controller_preview_var_previewActionItems_fave_action_title,
                controller_preview_var_previewActionItems_unfave_action_title
        
    }
}
