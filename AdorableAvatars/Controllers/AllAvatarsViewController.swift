//
//  AllAvatarsViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

public enum AllAvatarsViewControllerAction: UIViewControllerAction {
    case push, schema
}

public struct AllAvatarsViewControllerReceivedData: UIViewControllerInputData {
    let adAvatar: ADAvatar?
}

class AllAvatarsViewController: UICommunicableViewController {
    private typealias This = AllAvatarsViewController
    
    static let collectionViewDefaultBottomConstaintConstant = CGFloat.init(10)
    static let createAvatarSegueIdentifier = "createAvatarSegue"
    static let collectionViewCellZibIdentifier = "UIAvatarCollectionViewCell"
    static let collectionViewCellIdentifier = "avatarCell"
    static let previewControllerIdentifier = "previewController"
    
    @IBOutlet weak var avatarsCollectionView: UICollectionView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var collectionbottomContraint: NSLayoutConstraint!
    
    var delegate: TabBarControllersAvatarDelegate?
    var isEditing_ = false {
        didSet {
            if self.isEditing_{
                self.navigationItem.leftBarButtonItems?[0].title = "\(Strings.controller_allavatars_var_isEditing_cancel)"
            }
            else {
                self.navigationItem.leftBarButtonItems?[0].title = "\(Strings.controller_allavatars_var_isEditing_edit)"
            }
            self.avatarsCollectionView.reloadData()
        }
    }
    
    private var containerAvatars: [AvatarContainer]?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController.init(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "\(Strings.controller_allavatars_var_searchController_placeholder)"
        searchController.definesPresentationContext = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
    
        return searchController
    }()
    
    private var previewingContext: UIViewControllerPreviewing?
    
    private var has3DTouch: Bool {
        return view.traitCollection.forceTouchCapability == UIForceTouchCapability.available
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSetup()
        
        navigationItem.searchController = searchController
        self.navigationController?.view.tintColor = #colorLiteral(red: 0.9294117647, green: 0.5411764706, blue: 0.09803921569, alpha: 1)
        treatTabCommunication()
        
        self.tabBarController?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        AvatarOptionsService.shared.saveDefaultAvatars()
        containerAvatars = try? CoreDataWrapper.getAllAvatars().avatarContainerArray()
        self.avatarsCollectionView.reloadData()
    }
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            if let tababarSize = self.tabBarController?.tabBar.frame.height {
                collectionbottomContraint.constant = keyboardRect.size.height - tababarSize + 5
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        collectionbottomContraint.constant = This.collectionViewDefaultBottomConstaintConstant
    }
    
    override func orderReceived(action: UIViewControllerAction?, receivedData: UIViewControllerInputData?) {
        if let action = action as? AllAvatarsViewControllerAction{
            switch action {
            case .push:
                self.performSegue(withIdentifier: This.createAvatarSegueIdentifier, sender: nil)
            case .schema:
                self.performSegue(withIdentifier: This.createAvatarSegueIdentifier, sender: nil)
            }
        }
    }
    
    override func sendOrders(destination: UIViewController, action: UIViewControllerAction?, receivedData: UIViewControllerInputData?) {
        if let navigationController = destination as? UINavigationController {
            if let createAvatarController = navigationController.viewControllers.first as? CreateAvatarViewController{
                createAvatarController.delegate = self
                if  let safeAction = action as? AllAvatarsViewControllerAction,
                    let data = receivedData as? AllAvatarsViewControllerReceivedData,
                    safeAction == .push {
                    
                    createAvatarController.action = CreateAvatarViewControllerAction.push
                    createAvatarController.inputData = CreateAvatarViewControllerReceivedData(initialAdAvatar: data.adAvatar)
                    self.action = nil
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.avatarsCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        self.avatarsCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        self.isEditing_ = false
    }
    
    private func collectionViewSetup() {
        avatarsCollectionView.register(
            UINib.init(
                nibName: This.collectionViewCellZibIdentifier,
                bundle: nil
            ),
            forCellWithReuseIdentifier: This.collectionViewCellIdentifier
        )
        
        avatarsCollectionView.dataSource = self
        avatarsCollectionView.delegate = self
        avatarsCollectionView.allowsMultipleSelection = true
        if has3DTouch {
            self.previewingContext = registerForPreviewing(with: self, sourceView: avatarsCollectionView)
        }
    }
    
    private func treatTabCommunication() {
        if let navigationController = self.tabBarController?.viewControllers?[1] as? UINavigationController {
            if let faveAvatarsController = navigationController.viewControllers.first as? FaveAvatarsViewController {
                faveAvatarsController.delegate = self
            }
        }
    }
    
    private func setupWarningLabel(showing show: Bool) {
        self.warningLabel.alpha = show ? 1:0
        self.warningLabel.text = "\(Strings.controller_allavatars_no_avatar_warning)"
    }
    
    @IBAction func editTapped(_ sender: Any) {
        self.isEditing_ = !self.isEditing_
    }
    
    @IBAction func whatsSendTapped(_ sender: Any) {
        
        let service = WhatsAppService.init()
        
        let alertController = AlertManagment.alertSendAsSticker {
            if let allAvatars = try? CoreDataWrapper.getAllAvatars() {
                do {
                    try service.sendStickers(fromAvatars: allAvatars)
                } catch {
                    self.present(AlertManagment.genericErrorAlert(withDescription: "Fail"), animated: true, completion: nil)
                }
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}

extension AllAvatarsViewController: AvatarCollectionViewCellDelegate {
    func avatarWasClosed(_ cell: UIAvatarCollectionViewCell) {
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
            if let visibleAvatarCell = visibleCell as? UIAvatarCollectionViewCell {
                visibleAvatarCell.isShaking = true
            }
        }
    }
    
    func avatarWasFavorite(_ cell: UIAvatarCollectionViewCell) {
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

extension AllAvatarsViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.searchController.isActive = false
    }
}

extension AllAvatarsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = containerAvatars?.count {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: This.collectionViewCellIdentifier, for: indexPath)
       
        if let avatarCell = cell as? UIAvatarCollectionViewCell,  let avatar = containerAvatars?[indexPath.row].avatar, let avatarName = avatar.name {
            let image: UIImage? = FileManager.default.getAvatarImage(withName: avatarName)
            
            avatarCell.setup(name: avatarName, image: image, isFaved: avatar.isFave, isShaking: self.isEditing_)
            avatarCell.delegate = self
            
            avatarCell.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(self.avatarCellLongPress(_:))))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        guard let avatarCell = cell as? UIAvatarCollectionViewCell,
              let avatar = containerAvatars?[indexPath.row].avatar,
              let avatarImage = avatarCell.avatarImage.image,
              let avatarName = avatar.name
              else {
            return
        }
        self.present(AlertManagment.avatarOptionsAlert(
            avatarName: avatarName,
            share: {
                AvatarOptionsService.shared.shareAvatarImage(avatarImage, controller: self)
            },
            rename: { (newName) in
                AvatarOptionsService.shared.renameAvatar(avatar, toName: newName, context: self)
                self.avatarsCollectionView.reloadData()
                self.delegate?.avatarWasRenamed(avatar: avatar)
            },
            image: avatarImage,
            isFave: avatar.isFave,
            context: self
        ), animated: true, completion: nil)
    }
    
    @objc func avatarCellLongPress(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            if self.isEditing_ == false {
                self.isEditing_ = true
            }
        }
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

extension AllAvatarsViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
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
            present(AlertManagment.genericErrorAlert(
                withDescription: "\(Strings.controller_allavatars_func_updateSearchResults_error_description)"),
                animated: true,
                completion: nil
            )
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.isEditing_ = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        if let context = self.previewingContext, has3DTouch{
            unregisterForPreviewing(withContext: context)
            self.previewingContext = searchController.registerForPreviewing(with: self, sourceView: self.avatarsCollectionView)
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        if let context = self.previewingContext, has3DTouch{
            unregisterForPreviewing(withContext: context)
            self.previewingContext = registerForPreviewing(with: self, sourceView: self.avatarsCollectionView)
        }
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
        guard let cell = self.avatarsCollectionView.cellForItem(at: indexPath) as? UIAvatarCollectionViewCell else {
            return nil
        }
        guard let previewController = storyboard?.instantiateViewController(withIdentifier: This.previewControllerIdentifier) as? PreviewViewController else {
            return nil
        }
        guard let avatarContainer = self.containerAvatars?[indexPath.row] else {
            return nil
        }
        
        self.isEditing_ = false
        let data = PreviewViewControllerReceivedData.init(image: cell.avatarImage.image, avatar: avatarContainer.avatar)
        
        let width = self.avatarsCollectionView.frame.width
        let height = width
        
        previewController.inputData = data
        previewController.preferredContentSize = CGSize.init(width: width, height: height)
        previewController.delegate = self
        self.searchController.searchBar.resignFirstResponder()
        
        return previewController
     }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) { }
}

extension AllAvatarsViewController: AvatarPeekPreviewDelegate{
    func avatarWasDesfavorite(_ avatar: Avatar) {
        avatar.isFave = !avatar.isFave
        CoreDataStack.saveContext()
        
        if let avatarContainerIndex = self.containerAvatars?.firstIndex(of: avatar) {
            let avatarIndexPath = IndexPath.init(row: avatarContainerIndex, section: 0)
            if let avatarCell = self.avatarsCollectionView.cellForItem(at: avatarIndexPath) as? UIAvatarCollectionViewCell{
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
            if let avatarCell = self.avatarsCollectionView.cellForItem(at: avatarIndexPath) as? UIAvatarCollectionViewCell{
                avatarCell.isFaved = avatar.isFave
                
                delegate?.avatarWasFavorite?(avatar: avatar)
            }
        }
    }
}

extension AllAvatarsViewController: TabBarControllersAvatarDelegate{
    func avatarWasRenamed(avatar: Avatar) {
        if let avatarIndex = self.containerAvatars?.firstIndex(of: avatar),
            let avatarCell = self.avatarsCollectionView.cellForItem(at: IndexPath.init(row: avatarIndex, section: 0)) as? UIAvatarCollectionViewCell{
            avatarCell.avatarName.text = avatar.name
        }
    }
    
    func avatarWasDesfavorite(avatar: Avatar){
        guard let avatarIndex = self.containerAvatars?.firstIndex(of: avatar) else {
            return
        }
        guard let avatarCell = self.avatarsCollectionView.cellForItem(at: IndexPath.init(row: avatarIndex, section: 0)) as? UIAvatarCollectionViewCell else {
            return
        }
        
        avatarCell.isFaved = false
    }
}

extension AllAvatarsViewController {
    enum Strings: String, Localizable {
        case    controller_allavatars_title,
                controller_allavatars_var_isEditing_cancel,
                controller_allavatars_var_isEditing_edit,
                controller_allavatars_var_searchController_placeholder,
                controller_allavatars_func_updateSearchResults_error_description,
                controller_allavatars_no_avatar_warning
    }
}
