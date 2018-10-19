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
    
    lazy override var previewActionItems: [UIPreviewActionItem] =
        {
            let shareAction = UIPreviewAction.init(title: "share", style: .default) { (action, controller) in
                
            }
            return [shareAction]
    }()
    
    public var dataReceived: DataToPreviewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dataReceived = self.dataReceived {
            self.previewImageView.image = dataReceived.image
        }
    }
}

//creating data struct
struct DataToPreviewController{
    let image: UIImage?
}
