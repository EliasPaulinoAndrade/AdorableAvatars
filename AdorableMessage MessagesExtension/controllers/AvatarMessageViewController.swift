//
//  AvatarMessageViewController2.swift
//  AdorableMessage MessagesExtension
//
//  Created by Elias Paulino on 02/11/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit
import Messages

class AvatarMessageViewController: MSMessagesAppViewController {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var diceImage: UIImageView!
    @IBOutlet weak var addAvatarImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var stickersPlace: UIView!
    
    private var stickersViewController: StickerAvatarsViewController!
    private let adorableAvatarsAppUrl = URL.init(string: "adorableAvatarsEliasPaulino://")
    
    private lazy var loadIndicator: UIActivityIndicatorView = {
        let loadIndicator = UIActivityIndicatorView.init()
        loadIndicator.frame.size = view.frame.size
        loadIndicator.center = self.view.center
        loadIndicator.color = UIColor.gray
        loadIndicator.hidesWhenStopped = true
        loadIndicator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.view.addSubview(loadIndicator)
        
        return loadIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        StickerAvatarsViewController.delegate = self
        stickersViewController = StickerAvatarsViewController()
        stickersViewController.section = .all
        stickersViewController.warningLabel = self.warningLabel
        
        self.addChild(stickersViewController)
        self.stickersPlace.addSubview(stickersViewController.view)
        setupStickersView()
        
        stickersViewController.didMove(toParent: self)
        stickersViewController.changeBackground()
        
        diceImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(diceTapped(_ :))))
        addAvatarImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(addTapped(_:))))
        segmentedControl.addTarget(self, action: #selector(segmentedChanged(_:)), for: .valueChanged)
        ADWrapper.shared.delegate = self
    }
    
    private func setupStickersView() {
        let width = self.stickersPlace.frame.width
        let height = self.stickersPlace.frame.height
        stickersViewController.view.frame.size.width = width
        stickersViewController.view.frame.size.height = height
        stickersViewController.view.center = CGPoint.init(x: width/2, y: height/2)
        self.loadIndicator.frame.size.height = self.view.frame.height
        self.loadIndicator.frame.size.width = self.view.frame.width
    }
    
    @objc private func segmentedChanged(_ recognizer: UITapGestureRecognizer) {
        stickersViewController.reloadStickers()
    }
    
    @objc private func addTapped(_ recognizer: UITapGestureRecognizer) {
        if let adorableAppURL = adorableAvatarsAppUrl {
            try? sharedApplication().open(adorableAppURL, options: [:]) { (sucess) in
                if !sucess {
                    self.present(AlertManagment.genericErrorAlert(
                        withDescription: "\(Strings.controller_messases_cant_open_adorable_app)"),
                        animated: true,
                        completion: nil
                    )
                }
            }
        }
    }
    
    @objc private func diceTapped(_ image: UIImageView) {
        self.loadIndicator.startAnimating()
        let randomInt = Int.random(in: 0...1000)
        ADWrapper.shared.randomAvatar(withBase: randomInt)
    }
    
    override func viewDidLayoutSubviews() {
        setupStickersView()
        stickersViewController.reloadStickers()
    }
}

extension AvatarMessageViewController: StickersDelegate {
    func avatarsToShow() -> [Avatar] {
        switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                let avatars = try? CoreDataWrapper.getAllAvatars()
                return avatars ?? []
            case 1:
                let avatars = try? CoreDataWrapper.getAllFavoriteAvatars()
                return avatars ?? []
        default:
                return []
        }
    }
}

extension AvatarMessageViewController: ADRandomAvatarDelegate {
    func randomAvatarDidFail(wrapper: ADWrapper, forNumber number: Int) {
        self.present(AlertManagment.networkErrorAlert {
            self.diceTapped(self.diceImage)
        }, animated: true, completion: nil)
    }
    
    func didLoadRandomAvatar(wrapper: ADWrapper, forNumber number: Int, image: UIImage, inPath path: URL) {
        guard let stickerImagePath = FileManager.default.saveRandomSticker(image: image) else {
            return
        }
        requestPresentationStyle(.compact)
        if let sticker = try? MSSticker.init(contentsOfFileURL: stickerImagePath, localizedDescription: "") {
            activeConversation?.insert(sticker, completionHandler: { (error) in
                if error != nil {
                    self.present(AlertManagment.genericErrorAlert(
                        withDescription: "\(Strings.controller_messages_cant_add_message_error)"),
                        animated: true,
                        completion: nil
                    )
                }
            })
        }
        self.loadIndicator.stopAnimating()
    }
}

extension AvatarMessageViewController {
    
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

extension AvatarMessageViewController {
    enum Strings: String, Localizable {
        case    controller_messages_cant_add_message_error,
                controller_messases_cant_open_adorable_app
    }
}
