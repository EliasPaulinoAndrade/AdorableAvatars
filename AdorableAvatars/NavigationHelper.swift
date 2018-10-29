//
//  AppHelper.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 28/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class NavigationHelper {
    static public var allAvatarsViewController: AllAvatarsViewController? {
        let appDelegate = UIApplication.shared.delegate
        guard   let tabbarController = appDelegate?.window??.rootViewController as? UITabBarController,
                let selectedNavigationController = tabbarController.viewControllers?.first as? UINavigationController,
                let allAvatarsViewController = selectedNavigationController.viewControllers.first as? AllAvatarsViewController
                else {
            
            return nil
        }
     
        return allAvatarsViewController
    }
    
    static func openAllAvatarsViewControllerFromPush(adAvatar: ADAvatar?) {
        guard let allAvatarsViewController = NavigationHelper.allAvatarsViewController else {
            return
        }
        
        allAvatarsViewController.action = AllAvatarsViewControllerAction.push
        allAvatarsViewController.inputData = AllAvatarsViewControllerReceivedData(adAvatar: adAvatar)
        
        if allAvatarsViewController.isViewLoaded {
            allAvatarsViewController.performSegue(withIdentifier: "createAvatarSegue", sender: nil)
        }
    }
    
    static func openCreateAvatarViewControllerFromRequest(){
        if let allAvatarsViewController = NavigationHelper.allAvatarsViewController {
            allAvatarsViewController.action = AllAvatarsViewControllerAction.schema
            
            if allAvatarsViewController.isViewLoaded {
                allAvatarsViewController.performSegue(withIdentifier: "createAvatarSegue", sender: nil)
            }
        }
    }
}
