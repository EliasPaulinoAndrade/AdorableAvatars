//
//  ViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var picker: AvatarPicker!
    @IBOutlet weak var colorPicker: UICollectionView!
    
    private var adorableAvatars = ADWrapper()
    private var avatar = ADAvatar.init()
    private var plistReader = PlistReader.init()
    
    lazy var loadIndicator: UIActivityIndicatorView = {
        let loadIndicator = UIActivityIndicatorView.init()
        loadIndicator.frame.size = view.frame.size
        loadIndicator.center = self.view.center
        loadIndicator.color = UIColor.gray
        loadIndicator.hidesWhenStopped = true
        loadIndicator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return loadIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.datasource = self
        adorableAvatars.delegate = self
        view.addSubview(loadIndicator)
        loadIndicator.startAnimating()
        adorableAvatars.findTypes()
        colorPicker.dataSource = self
        colorPicker.delegate = self
    }
}

extension ViewController: ADDelegate {
    func didLoadAvatarImage(wrapper: ADWrapper, image: UIImage) {
        
        self.picker.image.image = image
        picker.stopLoading()
    }
    
    func avatarLoadDidFail(wrapper: ADWrapper, for avatar: ADAvatar) {
        print("erro")
    }
    
    func avatarTypesLoadDidFail(wrapper: ADWrapper) {
        print("erro")
    }
    
    func didLoadAvatarTypes(wrapper: ADWrapper) {
        if let eye = wrapper.components?.eyesNumbers.first, let nose = wrapper.components?.noseNumbers.first, let month = wrapper.components?.mouthsNumbers.first {
            avatar.eye = eye
            avatar.month = month
            avatar.nose = nose
            adorableAvatars.getImage(for: avatar)
        }
        loadIndicator.stopAnimating()
    }
}

extension ViewController: AvatarPickerDelegate {
    func nextTapped(_ picker: AvatarPicker, inPart avatarComponent: AvatarComponents, toNumber number: Int) {
        switch avatarComponent {
        case .eye:
            if let eye = adorableAvatars.components?.eyesNumbers[number] {
                avatar.eye = eye
            }
        case .month:
            if let month = adorableAvatars.components?.mouthsNumbers[number] {
                avatar.month = month
            }
        case .nose:
            if let nose = adorableAvatars.components?.noseNumbers[number] {
                avatar.nose = nose
            }
        }
        picker.startLoading()
        adorableAvatars.getImage(for: avatar)
    }
    
    func prevTapped(_ picker: AvatarPicker, inPart avatarComponent: AvatarComponents, toNumber number: Int) {
        switch avatarComponent {
        case .eye:
            if let eye = adorableAvatars.components?.eyesNumbers[number] {
                avatar.eye = eye
            }
        case .month:
            if let month = adorableAvatars.components?.mouthsNumbers[number] {
                avatar.month = month
            }
        case .nose:
            if let nose = adorableAvatars.components?.noseNumbers[number] {
                avatar.nose = nose
            }
        }
        picker.startLoading()
        adorableAvatars.getImage(for: avatar)
    }
}

extension ViewController: AvatarPickerDatasource {
    func initialValue(picker: AvatarPicker, forComponent component: AvatarComponents) -> Int {
        return 0
    }
    
    func numberOfTypes(picker: AvatarPicker, forComponent component: AvatarComponents) -> Int {
        switch component {
        case .eye:
            return self.adorableAvatars.components?.eyes.count ?? 0
        case .nose:
            return self.adorableAvatars.components?.noses.count ?? 0
        case .month:
            return self.adorableAvatars.components?.mouths.count ?? 0
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return plistReader.colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        
        cell.backgroundColor = plistReader.colors[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        return CGSize.init(width: height, height: height)
    }
}

