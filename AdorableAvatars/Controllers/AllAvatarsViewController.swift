//
//  AllAvatarsViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit


public enum AllAvatarsViewControllerAction {
    case push, normal
}

public struct AllAvatarsViewControllerReceivedData {
    let adAvatar: ADAvatar?
}

class AllAvatarsViewController: UIViewController {

    @IBOutlet weak var avatarsCollectionView: UICollectionView!
    
    public var delegate: FavoriteAvatarDelegate?
    public var action: AllAvatarsViewControllerAction?
    public var data: AllAvatarsViewControllerReceivedData?
    
    private var containerAvatars: [AvatarContainer]? = try? CoreDataWrapper.getAllAvatars().avatarContainerArray()
    
    public var isEditing_ = false {
        didSet {
            if self.isEditing_{
                self.navigationItem.rightBarButtonItems?[1].title = "Cancel"
            }
            else {
                self.navigationItem.rightBarButtonItems?[1].title = "Edit"
            }
            self.avatarsCollectionView.reloadData()
        }
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Avatars"
        searchController.definesPresentationContext = true
        searchController.delegate = self
    
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarsCollectionView.register(UINib.init(nibName: "AvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "avatarCell")
        
        avatarsCollectionView.dataSource = self
        avatarsCollectionView.delegate = self
        avatarsCollectionView.allowsMultipleSelection = true
        
        registerForPreviewing(with: self, sourceView: avatarsCollectionView)
        
        navigationItem.searchController = searchController
        
        if let navigationController = self.tabBarController?.viewControllers?[1] as? UINavigationController {
            if let faveAvatarsController = navigationController.viewControllers.first as? FaveAvatarsViewController {
                faveAvatarsController.delegate = self
            }
        }
        
        if let action = self.action {
            switch action {
            case .push:
                self.performSegue(withIdentifier: "createAvatarSegue", sender: nil)
            case .normal:
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.avatarsCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.isEditing_ = false
        
        if let navigationController = segue.destination as? UINavigationController {
            if let createAvatarController = navigationController.viewControllers.first as? CreateAvatarViewController{
                createAvatarController.delegate = self
                if let action = self.action, action == .push {
                    
                    createAvatarController.action = .push
                    createAvatarController.data = CreateAvatarViewControllerReceivedData(initialAdAvatar: self.data?.adAvatar)
                    self.action = .normal
                }
            }
        }
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.isEditing_ = !self.isEditing_
    }
}

extension AllAvatarsViewController: AvatarCollectionViewCellDelegate {
    func avatarWasClosed(_ cell: AvatarCollectionViewCell) {
        guard let indexPath = self.avatarsCollectionView.indexPath(for: cell) else {
            return
        }
        if let avatar = self.containerAvatars?[indexPath.row] {
            present(AlertManagment.alertRemoveAvatar {
                self.removeAvatar(avatarContainer: avatar, alIndexPath: indexPath)
            }, animated: true, completion: nil)
        }
    }
    
    func removeAvatar(avatarContainer: AvatarContainer, alIndexPath indexPath: IndexPath) {
        let avatar = avatarContainer.avatar
        let coreDataContext = CoreDataStack.persistentContainer.viewContext
        
        self.containerAvatars?.remove(at: indexPath.row)
        self.avatarsCollectionView.deleteItems(at: [indexPath])
        
        reloadVisibleCells()
        
        if avatar.isFave {
            delegate?.avatarWasDesfavorite(avatar: avatar)
        }
        if let avatarName = avatar.name {
            FileManager.default.deleteAvatarImage(withName: avatarName)
            coreDataContext.delete(avatar)
            try? coreDataContext.save()
        }
    }
    
    func reloadVisibleCells() {
        for visibleCell in self.avatarsCollectionView.visibleCells {
            if let visibleAvatarCell = visibleCell as? AvatarCollectionViewCell {
                visibleAvatarCell.isShaking = true
            }
        }
    }
    
    func avatarWasFavorite(_ cell: AvatarCollectionViewCell) {
        if let avatarIndex = self.avatarsCollectionView.indexPath(for: cell)?.row, let avatarContainers = self.containerAvatars {
            let avatar = avatarContainers[avatarIndex].avatar
            avatar.isFave = !avatar.isFave
            CoreDataStack.saveContext()
            
            if avatar.isFave{
                delegate?.avatarWasFavorite?(avatar: avatar)
                
            } else {
                delegate?.avatarWasDesfavorite(avatar: avatar)
            }
        }
    }
}

extension AllAvatarsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return containerAvatars?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath)
       
        if let avatarCell = cell as? AvatarCollectionViewCell,  let avatar = containerAvatars?[indexPath.row].avatar, let avatarName = avatar.name {
            let image = FileManager.default.getAvatar(withName: avatarName)
            
            avatarCell.setup(name: avatarName, image: image, isFaved: avatar.isFave, isShaking: self.isEditing_)
            avatarCell.delegate = self
            avatarCell.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(self.avatarCellLongPress(_:))))
        }
        
        return cell
    }
    
    @objc func avatarCellLongPress(_ sender: AvatarCollectionViewCell) {
        self.isEditing_ = true
        
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

extension AllAvatarsViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else {
            return
        }
        guard !text.isEmpty else {
            let avatarContainers = try? CoreDataWrapper.getAllAvatars().avatarContainerArray()
            self.containerAvatars = avatarContainers
            self.avatarsCollectionView.reloadData()
            return
        }
        do {
            let avatarContainers = try CoreDataWrapper.findAvatars(byName: text).avatarContainerArray()
            self.containerAvatars = avatarContainers
            self.avatarsCollectionView.reloadData()
            
        } catch {
            present(AlertManagment.genericErrorAlert(withDescription: "Error While Removing Avatar"), animated: true, completion: nil)
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.isEditing_ = false
    }
}

extension AllAvatarsViewController: CreateAvatarDelegate {
    func avatarWasCreated(controller: CreateAvatarViewController, avatar: Avatar) {
        
        if let avatarContainers = self.containerAvatars {
            let lastPosition = IndexPath.init(item: avatarContainers.count - 1, section: 0)
            self.avatarsCollectionView.scrollToItem(at: lastPosition, at: .bottom, animated: false)
            
            let avatarPosition = IndexPath.init(row: avatarContainers.count, section: 0)
            let avatarContainer = AvatarContainer.init(isSelected: false, avatar: avatar)
            self.containerAvatars?.append(avatarContainer)
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
        guard let avatarContainer = self.containerAvatars?[indexPath.row] else {
            return nil
        }
        let data = DataToPreviewController.init(image: cell.avatarImage.image, avatar: avatarContainer.avatar)
        
        let width = self.avatarsCollectionView.frame.width
        let height = width
        
        previewController.dataReceived = data
        previewController.preferredContentSize = CGSize.init(width: width, height: height)
        previewController.delegate = self
        
        return previewController
     }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) { }
}

extension AllAvatarsViewController: AvatarPreviewDelegate{
    func avatarWasDesfavorite(_ avatar: Avatar) {
        
        avatar.isFave = !avatar.isFave
        CoreDataStack.saveContext()
        
        if let avatarContainerIndex = self.containerAvatars?.firstIndex(of: avatar) {
            let avatarIndexPath = IndexPath.init(row: avatarContainerIndex, section: 0)
            if let avatarCell = self.avatarsCollectionView.cellForItem(at: avatarIndexPath) as? AvatarCollectionViewCell{
                avatarCell.isFaved = avatar.isFave
                
                delegate?.avatarWasDesfavorite(avatar: avatar)
            }
        }
    }
    
    func avatarWasFavorite(_ avatar: Avatar) {
        
        avatar.isFave = !avatar.isFave
        CoreDataStack.saveContext()
        
        if let avatarIndex = self.containerAvatars?.firstIndex(of: avatar) {
            let avatarIndexPath = IndexPath.init(row: avatarIndex, section: 0)
            if let avatarCell = self.avatarsCollectionView.cellForItem(at: avatarIndexPath) as? AvatarCollectionViewCell{
                avatarCell.isFaved = avatar.isFave
                
                delegate?.avatarWasFavorite?(avatar: avatar)
            }
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

extension AllAvatarsViewController: FavoriteAvatarDelegate{
    
    func avatarWasDesfavorite(avatar: Avatar){
        guard let avatarIndex = self.containerAvatars?.firstIndex(of: avatar) else {
            return
        }
        guard let avatarCell = self.avatarsCollectionView.cellForItem(at: IndexPath.init(row: avatarIndex, section: 0)) as? AvatarCollectionViewCell else {
            return
        }
        
        avatarCell.isFaved = false
    }
}
