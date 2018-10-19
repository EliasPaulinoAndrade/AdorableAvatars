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
    public var delegate: AvatarSharedDelegate?
    
    private var avatar: Avatar?
    
    lazy override var previewActionItems: [UIPreviewActionItem] = {
        
            let shareAction = UIPreviewAction.init(title: "share", style: .default) { (action, controller) in
                
                if let avatar = self.avatar, let image = self.previewImageView.image {
                    
                    self.delegate?.avatarShared(avatar, withImage: image)
                }
            }
            return [shareAction]
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
