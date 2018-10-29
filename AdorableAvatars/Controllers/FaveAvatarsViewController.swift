//
//  FaveAvatarsViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

protocol LocalizableFavAvatarsController {
    associatedtype Strings: Localizable
}

class FaveAvatarsViewController: UIViewController {

    @IBOutlet weak var avatarsCollectionView: UICollectionView!
    @IBOutlet weak var warningLabel: UILabel!
    
    public var delegate: FavoriteAvatarDelegate?
    
    private var avatars: [Avatar]? = try? CoreDataWrapper.getAllFavoriteAvatars()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetup()
        
        treatTabCommunication()
    }
    override func viewDidLayoutSubviews() {
        self.avatarsCollectionView.reloadData()
    }
    
    private func collectionViewSetup() {
        avatarsCollectionView.register(UINib.init(nibName: "UIAvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "avatarCell")
    
        self.avatarsCollectionView.delegate = self
        self.avatarsCollectionView.dataSource = self
    
        registerForPreviewing(with: self, sourceView: avatarsCollectionView)
    }
    
    private func treatTabCommunication() {
        if let navigationController = self.tabBarController?.viewControllers?.first as? UINavigationController {
            if let allAvatarsController = navigationController.viewControllers.first as? AllAvatarsViewController {
                allAvatarsController.delegate = self
            }
        }
    }
    
    private func setupWarningLabel(showing show: Bool) {
        self.warningLabel.alpha = show ? 1:0
        self.warningLabel.text = "\(Strings.controller_favAvatars_no_avatar_warning)"
    }
}

extension FaveAvatarsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = avatars?.count {
            if count == 0 {
                setupWarningLabel(showing: true)
            } else {
                setupWarningLabel(showing: false)
            }
            return count
        } else {
            setupWarningLabel(showing: true)
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath)
        
        if let avatarCell = cell as? UIAvatarCollectionViewCell,  let avatar = avatars?[indexPath.row], let avatarName = avatar.name {
            let image: UIImage? = FileManager.default.getAvatarImage(withName: avatarName)
            avatarCell.avatarImage.image = image
            avatarCell.avatarName.text = avatarName.capitalized
            avatarCell.faveImage.layer.opacity = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size: CGSize?
        
        if self.view.isStanding() {
            let width = collectionView.frame.size.width/2 - 10
            let height = 1.35 * width
            
            size = CGSize.init(width: width, height: height)
        } else {
            let width = collectionView.frame.size.width/4 - 10
            let height = 1.35 * width
            
            size = CGSize.init(width: width, height: height)
        }
        
        return size!
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
        guard let cell = self.avatarsCollectionView.cellForItem(at: indexPath) as? UIAvatarCollectionViewCell else {
            return nil
        }
        guard let previewController = storyboard?.instantiateViewController(withIdentifier: "previewController") as? PreviewViewController else {
            return nil
        }
        guard let avatar = self.avatars?[indexPath.row] else {
            return nil
        }
        let data = PreviewViewControllerReceivedData.init(image: cell.avatarImage.image, avatar: avatar)
        
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

extension FaveAvatarsViewController: LocalizableFavAvatarsController {
    
    enum Strings: String, Localizable {
        case    controller_favAvatars_title,
                controller_favAvatars_no_avatar_warning
        
        var comment: String {
            switch self {
            default:
                return "default"
            }
        }
    }
}
