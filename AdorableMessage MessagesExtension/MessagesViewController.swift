//
//  MessagesViewController.swift
//  AdorableMessage MessagesExtension
//
//  Created by Elias Paulino on 26/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit
import Messages

protocol LocalizableMessagesController {
    associatedtype Strings: Localizable
}

class MessagesViewController: MSMessagesAppViewController {
    
    @IBOutlet weak var stickersCollectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var diceImageView: UIImageView!
    @IBOutlet weak var addImageView: UIImageView!
    
    private lazy var loadIndicator: UIActivityIndicatorView = {
        let loadIndicator = UIActivityIndicatorView.init()
        loadIndicator.frame.size = view.frame.size
        loadIndicator.center = self.view.center
        loadIndicator.color = UIColor.gray
        loadIndicator.hidesWhenStopped = true
        loadIndicator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return loadIndicator
    }()
    
    private var containerAvatars: [AvatarContainer]? = try? CoreDataWrapper.getAllAvatars().avatarContainerArray()
    
    private var containerFavAvatars: [AvatarContainer]? = try? CoreDataWrapper.getAllFavoriteAvatars().avatarContainerArray()
    
    private var adorableWrapper: ADWrapper = ADWrapper.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stickersCollectionView.register(UINib.init(nibName: "UIAvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "avatarCell")
        
        stickersCollectionView.dataSource = self
        stickersCollectionView.delegate = self
        stickersCollectionView.allowsMultipleSelection = true
        adorableWrapper.delegate = self
        
        self.view.addSubview(loadIndicator)
     
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlChanged(_:)), for: UIControl.Event.valueChanged)
        
        diceImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.diceTapped(_:))))
        
        addImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.addTapped(_:))))
        
    }
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl){
        self.stickersCollectionView.reloadData()
    }
    
    @objc private func diceTapped(_ sender: UIImageView){
        let avatarNumber = Int.random(in: 0..<1000)
        loadIndicator.startAnimating()
        adorableWrapper.randomAvatar(withBase: avatarNumber)
    }
    
    @objc private func addTapped(_ sender: UIImageView){
        
        if let appUrl = URL.init(string: "adorableAvatarsEliasPaulino://") {
        
            try? sharedApplication().open(appUrl, options: [:]) { (sucess) in
                print(sucess)
            }
           
        }
    }
    
    func sharedApplication() throws -> UIApplication {
        var responder: UIResponder? = self
        
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }
            
            responder = responder?.next
        }
        
        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }
}

extension MessagesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            return self.containerAvatars?.count ?? 0
        case 1:
            return self.containerFavAvatars?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath)
        
        if let avatarCell = cell as? UIAvatarCollectionViewCell {
            var avatar: Avatar?
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                avatar = self.containerAvatars?[indexPath.row].avatar
            case 1:
                avatar = self.containerFavAvatars?[indexPath.row].avatar
            default:
                avatar = nil
            }
            
            if let avatar = avatar, let avatarName = avatar.name {
                let image = FileManager.default.getAvatar(withName: avatarName)
                avatarCell.setup(name: avatarName, image: image, isFaved: avatar.isFave, isShaking: false)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize?
        
        let width = collectionView.frame.size.width/3 - 10
        let height = 1.35 * width
        
        cellSize = CGSize.init(width: width, height: height)
        
        if let size = cellSize, size.width > 180 {
            let width = collectionView.frame.size.width/5 - 10
            let height = 1.35 * width
            
            cellSize = CGSize.init(width: width, height: height)
        }
        
        return cellSize!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        var avatarContainer: AvatarContainer?
        
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            avatarContainer = self.containerAvatars?[indexPath.row]
        case 1:
            avatarContainer = self.containerFavAvatars?[indexPath.row]
        default:
            avatarContainer = nil
        }
        
        guard let avatar = avatarContainer?.avatar,
              let avatarName = avatar.name,
              let image = FileManager.default.getAvatar(withName: avatarName),
              let conversetion = self.activeConversation
              else {
            return
        }
        
        self.present(AlertManagment.sendAvatarAlert(answered: { (includeName) in
            self.showMessage(avatarName: avatarName, conversetion: conversetion, image: image, includeName: includeName)
        }), animated: true, completion: nil)

    }
    
    func showMessage(avatarName: String, conversetion: MSConversation, image: UIImage, includeName: Bool) {
        var messageName: String?
        if includeName{
            messageName = avatarName
        } else {
            messageName = ""
        }
        
        guard let message = self.composeMessage(withImage: image, andName: messageName ?? "", session: conversetion.selectedMessage?.session) else {
            return
        }
        
        self.requestPresentationStyle(.compact)
        
        conversetion.insert(message) { (error) in
            if error != nil {
                self.present(AlertManagment.genericErrorAlert(
                    withDescription: "\(Strings.controller_messages_cant_add_message_error)"
                    ),
                             animated: true,
                             completion: nil
                )
            }
        }
    }
    
    func composeMessage(withImage image: UIImage, andName name: String = "", session: MSSession? = nil) -> MSMessage? {
        let layout = MSMessageTemplateLayout()
        
        layout.image = image
        layout.caption = name
        
        let message = MSMessage(session: session ?? MSSession())
        
        message.layout = layout
        
        return message
    }
}

extension MessagesViewController: ADRandomAvatarDelegate {
    func randomAvatarDidFail(wrapper: ADWrapper, forNumber number: Int) {
        self.present(AlertManagment.networkErrorAlert {
            self.diceTapped(self.diceImageView)
        }, animated: true, completion: nil)
    }
    
    func didLoadRandomAvatar(wrapper: ADWrapper, forNumber number: Int, image: UIImage) {
        loadIndicator.stopAnimating()
        guard let conversetion = self.activeConversation else {
                return
        }
        
        guard let message = composeMessage(withImage: image, andName: "", session: conversetion.selectedMessage?.session)
            else {
                return
        }
        
        requestPresentationStyle(.compact)
        
        conversetion.insert(message) { (error) in
            if error != nil {
                self.present(AlertManagment.genericErrorAlert(
                        withDescription: "\(Strings.controller_messages_cant_add_message_error)"
                    ),
                    animated: true,
                    completion: nil
                )
            }
        }
    }
}



extension MessagesViewController: LocalizableMessagesController {
    
    enum Strings: String, Localizable {
        case controller_messages_cant_add_message_error
        
        var comment: String {
            switch self {
            default:
                return "default"
            }
        }
    }
}
