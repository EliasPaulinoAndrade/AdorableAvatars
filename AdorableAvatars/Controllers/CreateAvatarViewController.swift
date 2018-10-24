//
//  ViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

public enum CreateAvatarViewControllerAction {
    case push
}

public struct CreateAvatarViewControllerReceivedData {
    let initialAdAvatar: ADAvatar?
}

class CreateAvatarViewController: UIViewController {
    @IBOutlet weak var picker: UIAvatarPicker!
    @IBOutlet weak var colorPicker: ColorPicker!
    
    private var currentAvatarImage: UIImage?
    private var adorableAvatars = ADWrapper()
    private var plistReader = PlistReader.init()
    private var avatar = ADAvatar.init()
   
    public var data: CreateAvatarViewControllerReceivedData?
    public var action: CreateAvatarViewControllerAction?
    public var delegate: CreateAvatarDelegate?
    
    private lazy var loadIndicator: UIActivityIndicatorView = {
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
        colorPicker.colors = plistReader.colors
        adorableAvatars.findTypes()
        colorPicker.datasource = self
        colorPicker.delegate = self
        
        if let action = self.action {
            switch action {
            case .push:
                showAvatarNameAlert()
            }
        }
        
        if let data = self.data {
            self.avatar = data.initialAdAvatar ?? self.avatar
            if let initalEye = data.initialAdAvatar?.eye, let initalNose = data.initialAdAvatar?.nose, let initialMonth = data.initialAdAvatar?.month {
//                self.picker.currentAvatar.eye = initalEye
//                self.picker.currentAvatar.nose = initalNose
//                self.picker.currentAvatar.month = initialMonth
                
            }
        }
    }
    
    private func showAvatarNameAlert(){
        present(AlertManagment.saveAvatarAlert(sucess: { (name) in
            if let image = self.currentAvatarImage, let name = name{
                self.saveAvatar(image: image, withName: name)
            }
        }), animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        showAvatarNameAlert()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    private func saveAvatar(image: UIImage, withName name: String) {
        guard let avatarsWithSameName =  try? CoreDataWrapper.findAvatars(byName: name), avatarsWithSameName.count == 0 else {
            self.present(AlertManagment.saveAvatarErrorAlert(name: name), animated: true, completion: nil)
            return
        }
        
        FileManager.default.saveAvatarImage(image, withName: name)
        
        let avatar = Avatar.init(name: name, isFave: false)
        CoreDataStack.saveContext()
        
        dismiss(animated: true) {
            self.delegate?.avatarWasCreated(controller: self, avatar: avatar)
        }
    }
}

extension CreateAvatarViewController: ADDelegate {
    func didLoadAvatarImage(wrapper: ADWrapper, image: UIImage) {
        self.picker.image.image = image
        self.currentAvatarImage = image
        picker.stopLoading()
    }
    
    func avatarLoadDidFail(wrapper: ADWrapper, for avatar: ADAvatar) {
       
        self.present(AlertManagment.networkErrorAlert(), animated: true, completion: nil)
        self.picker.stopLoading()
    }
    
    func avatarTypesLoadDidFail(wrapper: ADWrapper) {
        self.present(AlertManagment.networkErrorAlert(), animated: true, completion: nil)
        self.picker.stopLoading()
    }
    
    func didLoadAvatarTypes(wrapper: ADWrapper) {
        
        if let eye = wrapper.components?.eyesNumbers.first, let nose = wrapper.components?.noseNumbers.first, let month = wrapper.components?.mouthsNumbers.first {
            
            if (action != nil && action != .push) || action == nil {
                avatar.eye = eye
                avatar.month = month
                avatar.nose = nose
                avatar.color = plistReader.colors[0]
            }
            
            picker.startLoading()
            adorableAvatars.getImage(for: avatar)
        }
        loadIndicator.stopAnimating()
    }
}

extension CreateAvatarViewController: APAvatarPickerDelegate {
    func nextTapped(_ picker: UIAvatarPicker, inPart avatarComponent: APAvatarComponents, toNumber number: Int) {
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
    
    func prevTapped(_ picker: UIAvatarPicker, inPart avatarComponent: APAvatarComponents, toNumber number: Int) {
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

extension CreateAvatarViewController: APAvatarPickerDatasource {
    func initialValue(picker: UIAvatarPicker, forComponent component: APAvatarComponents) -> Int {
        return 0
    }
    
    func numberOfTypes(picker: UIAvatarPicker, forComponent component: APAvatarComponents) -> Int {
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

extension CreateAvatarViewController: ColorPickerDatasource, ColorPickerDelegate {
    func initialColor(colorPicker: ColorPicker) -> Int {
        return 0
    }
    
    func imageForSelectColor(colorPicker: ColorPicker) -> UIImage? {
        return UIImage.init(named: "checked")
    }
    
    func colorWasSelected(_ colorPicker: ColorPicker, atPosition position: Int) {
        self.avatar.color = plistReader.colors[position]
        picker.startLoading()
        adorableAvatars.getImage(for: avatar)
    }
}

