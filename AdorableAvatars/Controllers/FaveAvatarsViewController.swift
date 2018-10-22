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
    
    public var delegate: FavoriteAvatarDelegate?
    
    private var avatars: [Avatar]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.avatars = try? CoreDataWrapper.getAllFavoriteAvatars()
        avatarsCollectionView.register(UINib.init(nibName: "AvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "avatarCell")
        
        self.avatarsCollectionView.delegate = self
        self.avatarsCollectionView.dataSource = self
        
        registerForPreviewing(with: self, sourceView: avatarsCollectionView)
        
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

extension FaveAvatarsViewController: UIViewControllerPreviewingDelegate{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.avatarsCollectionView.indexPathForItem(at: location) else {
            return nil
        }
        guard let cell = self.avatarsCollectionView.cellForItem(at: indexPath) as? AvatarCollectionViewCell else {
            return nil
        }
        guard let previewController = storyboard?.instantiateViewController(withIdentifier: "previewController") as? PreviewViewController else {
            return nil
        }
        guard let avatar = self.avatars?[indexPath.row] else {
            return nil
        }
        let data = DataToPreviewController.init(image: cell.avatarImage.image, avatar: avatar)
        
        let width = self.avatarsCollectionView.frame.width
        let height = width
        
        
        previewController.dataReceived = data
        previewController.preferredContentSize = CGSize.init(width: width, height: height)
        previewController.delegate = self
        
        return previewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) { }
}

extension FaveAvatarsViewController: AvatarPreviewDelegate{
    
    func avatarWasDesfavorite(_ avatar: Avatar) {
        avatar.isFave = !avatar.isFave
        CoreDataStack.saveContext()
        
        if let avatarIndex = self.avatars?.firstIndex(of: avatar) {
            
            let avatarIndexPath = IndexPath.init(row: avatarIndex, section: 0)
            self.avatars?.remove(at: avatarIndex)
            self.avatarsCollectionView.deleteItems(at: [avatarIndexPath])
            delegate?.avatarWasDesfavorite(avatar: avatar)
        }
    }
    
    func avatarShared(_ avatar: Avatar, withImage image: UIImage) {
        let activityController: UIActivityViewController = {
         
            let activityController = UIActivityViewController.init(activityItems: [image], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = self.view
            
            return activityController
        }()
        
        self.present(activityController, animated: true, completion: nil)
    }
    
}
