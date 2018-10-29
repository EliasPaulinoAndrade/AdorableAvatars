//
//  AppHelper.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 28/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class AppHelper {
    static public var allAvatarsViewController: AllAvatarsViewController? {
        let appDelegate = UIApplication.shared.delegate
        guard let tabbarController = appDelegate?.window??.rootViewController as? UITabBarController else {
            
            return nil
        }
        
        guard let selectedNavigationController = tabbarController.viewControllers?.first as? UINavigationController else {
            
            return nil
        }
        
        guard let allAvatarsViewController = selectedNavigationController.viewControllers.first as? AllAvatarsViewController else {
            return nil
        }
        
        return allAvatarsViewController
    }
    
    static func openAllAvatarsViewControllerFromPush(adAvatar: ADAvatar?) {
        guard let allAvatarsViewController = AppHelper.allAvatarsViewController else {
            return
        }
        
        allAvatarsViewController.action = .push
        allAvatarsViewController.data = AllAvatarsViewControllerReceivedData(adAvatar: adAvatar)
        
        if allAvatarsViewController.isViewLoaded {
            allAvatarsViewController.performSegue(withIdentifier: "createAvatarSegue", sender: nil)
        }
    }
    
    static func openCreateAvatarViewControllerFromRequest(){
        if let allAvatarsViewController = AppHelper.allAvatarsViewController {
            allAvatarsViewController.action = .schema
            
            if allAvatarsViewController.isViewLoaded {
                allAvatarsViewController.performSegue(withIdentifier: "createAvatarSegue", sender: nil)
            }
        }
    }
}
