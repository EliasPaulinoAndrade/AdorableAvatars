//
//  AvatarOptionsService.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 01/11/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

struct AvatarOptionsService {
    public static var shared = AvatarOptionsService.init()
    
    func shareAvatarImage(_ image : UIImage, controller: UIViewController) {
        let activityController: UIActivityViewController = {
            
            let activityController = UIActivityViewController.init(activityItems: [image], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = controller.view
            
            return activityController
        }()
        
        controller.present(activityController, animated: true, completion: nil)
    }
    
    func faveAvatar(_ avatar: Avatar) {
        
    }
}
