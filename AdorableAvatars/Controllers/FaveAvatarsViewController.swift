//
//  FaveAvatarsViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class FaveAvatarsViewController: UIViewController {

    @IBOutlet weak var avatarsCollectionView: UICollectionView!
    
    private var avatars: [Avatar]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.avatars = try? CoreDataWrapper.getAllFavoriteAvatars()
        avatarsCollectionView.register(UINib.init(nibName: "AvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "avatarCell")
        
        self.avatarsCollectionView.delegate = self
        self.avatarsCollectionView.dataSource = self
        
        
        if let navigationController = self.tabBarController?.viewControllers?.first as? UINavigationController {
            if let allAvatarsController = navigationController.viewControllers.first as? AllAvatarsViewController {
                allAvatarsController.delegate = self
            }
        }
        
    }
}

extension FaveAvatarsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath)
        
        if let avatarCell = cell as? AvatarCollectionViewCell,  let avatar = avatars?[indexPath.row], let avatarName = avatar.name {
            let image = FileManager.default.getAvatar(withName: avatarName)
            avatarCell.avatarImage.image = image
            avatarCell.avatarName.text = avatarName
            avatarCell.faveImage.layer.opacity = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/2 - 10
        let height = 1.35 * width
        
        let size = CGSize.init(width: width, height: height)
        return size
    }
}

extension FaveAvatarsViewController: FavoriteAvatarDelegate {
    func avatarWasFavorite(avatar: Avatar) {
        self.avatars?.append(avatar)
        self.avatarsCollectionView.reloadData()
    }
    
    func avatarWasDesfavorite(avatar: Avatar) {
        if let avatarIndex = self.avatars?.firstIndex(of: avatar){
            self.avatars?.remove(at: avatarIndex)
            self.avatarsCollectionView.reloadData()
        }
    }
}
