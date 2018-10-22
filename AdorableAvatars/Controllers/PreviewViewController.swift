//
//  PreviewViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    @IBOutlet weak var previewImageView: UIImageView!
    
    public var dataReceived: DataToPreviewController?
    public var delegate: AvatarPreviewDelegate?
    
    private var avatar: Avatar?
    
    lazy override var previewActionItems: [UIPreviewActionItem] = {
        guard let avatar = self.avatar else {
            return []
        }
        
        let shareAction = UIPreviewAction.init(title: "Share Avatar", style: .default) { (action, controller) in
            if let image = self.previewImageView.image {
                self.delegate?.avatarShared?(avatar, withImage: image)
            }
        }
    
        let faveAction = UIPreviewAction.init(title: avatar.isFave ? "It`s NOT My Favorite" : "Its My Favorite", style: .default) { (action, controller) in
            
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
        
        
        if let dataReceived = self.dataReceived {
            self.previewImageView.image = dataReceived.image
            self.avatar = dataReceived.avatar
        }
    }
}

//creating data struct
struct DataToPreviewController{
    let image: UIImage?
    let avatar: Avatar?
}
