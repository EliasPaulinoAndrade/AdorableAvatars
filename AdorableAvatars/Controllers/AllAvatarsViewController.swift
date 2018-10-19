//
//  AllAvatarsViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class AllAvatarsViewController: UIViewController {

    @IBOutlet weak var avatarsCollectionView: UICollectionView!
    
    private var avatars: [Avatar]? = try? CoreDataWrapper.getAllAvatars()
    
    public var delegate: FavoriteAvatarDelegate?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Avatars"
        searchController.definesPresentationContext = true
        
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarsCollectionView.register(UINib.init(nibName: "AvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "avatarCell")
        
        avatarsCollectionView.dataSource = self
        avatarsCollectionView.delegate = self
    
        registerForPreviewing(with: self, sourceView: avatarsCollectionView)
        
        navigationItem.searchController = searchController
        
    }
    
    override func viewDidLayoutSubviews() {
        avatarsCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let navigationController = segue.destination as? UINavigationController {
            if let createAvatarController = navigationController.viewControllers.first as? CreateAvatarViewController{
                createAvatarController.delegate = self
            }
        }
    }
}


extension AllAvatarsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AvatarCollectionViewCellDelegate{
    func avatarWasFavorite(_ cell: AvatarCollectionViewCell) {
        if let avatarIndex = self.avatarsCollectionView.indexPath(for: cell)?.row, let avatars = self.avatars {
            let avatar = avatars[avatarIndex]
            avatar.isFave = !avatar.isFave
            CoreDataStack.saveContext()
            
            if avatar.isFave{
                delegate?.avatarWasFavorite(avatar: avatar)
            } else {
                delegate?.avatarWasDesfavorite(avatar: avatar)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatars?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath)
       
        if let avatarCell = cell as? AvatarCollectionViewCell,  let avatar = avatars?[indexPath.row], let avatarName = avatar.name {
            let image = FileManager.default.getAvatar(withName: avatarName)
            avatarCell.avatarImage.image = image
            avatarCell.avatarName.text = avatarName
            
            avatarCell.isFaved = avatar.isFave
            avatarCell.delegate = self
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

extension AllAvatarsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("UPDATE")
    }
}

extension AllAvatarsViewController: CreateAvatarDelegate {
    func avatarWasCreated(controller: CreateAvatarViewController, avatar: Avatar) {
        
        if let avatars = self.avatars{
            let lastPosition = IndexPath.init(item: avatars.count - 1, section: 0)
            self.avatarsCollectionView.scrollToItem(at: lastPosition, at: .bottom, animated: false)
            
            let avatarPosition = IndexPath.init(row: avatars.count, section: 0)
            self.avatars?.append(avatar)
            self.avatarsCollectionView.insertItems(at: [avatarPosition])
            
            self.avatarsCollectionView.scrollToItem(at: avatarPosition, at: .bottom, animated: true)
        }
    }
}

extension AllAvatarsViewController: UIViewControllerPreviewingDelegate{
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
        
        let data = DataToPreviewController.init(image: cell.avatarImage.image)
        
        let width = self.avatarsCollectionView.frame.width
        let height = width
        
        
        
        previewController.dataReceived = data
        previewController.preferredContentSize = CGSize.init(width: width, height: height)
        
        return previewController
     }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        //showDetailViewController(viewControllerToCommit, sender: self)
    }
}


