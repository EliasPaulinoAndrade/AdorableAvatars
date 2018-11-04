//
//  ViewController.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

public enum CreateAvatarViewControllerAction: UIViewControllerAction {
    case push
}

public struct CreateAvatarViewControllerReceivedData: UIViewControllerInputData {
    let initialAdAvatar: ADAvatar?
}

class CreateAvatarViewController: UICommunicableViewController {
    private typealias This = CreateAvatarViewController
    
    static let colorPickerImageCheckName = "checkColor"
    
    @IBOutlet weak var picker: UIAvatarPicker!
    @IBOutlet weak var colorPicker: UIColorPicker!
    @IBOutlet weak var colorPickerContainer: UIView!
    @IBOutlet weak var radiusSlider: UIRadiusSlider!
    
    private var currentAvatarImage: UIImage?
    private var plistReader = PlistReader.init()
    private var avatar = ADAvatar.init()
    private var pickerColors: [PickerColor]?
   
    public var delegate: CreateAvatarDelegate?
    
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
        
        picker.delegate = self
        picker.datasource = self
        ADWrapper.shared.delegate = self
        colorPicker.datasource = self
        colorPicker.delegate = self
        
        self.picker.radius = radiusSlider.value
        self.radiusSlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        self.pickerColors = plistReader.colors.pickerColorArray()
        
        loadIndicator.startAnimating()
        
        if ADWrapper.shared.components != nil{
            setupAvatarWithTypes(wrapper: ADWrapper.shared)
        } else {
            ADWrapper.shared.findTypes()
        }
    }
    
    override func orderReceived(action: UIViewControllerAction?, receivedData: UIViewControllerInputData?) {
        if let safeAction = action as? CreateAvatarViewControllerAction {
            switch safeAction {
            case .push:
                showAvatarNameAlert()
            }
        }
        
        if let data = receivedData as? CreateAvatarViewControllerReceivedData{
            self.avatar = data.initialAdAvatar ?? self.avatar
            //            if let initalEye = data.initialAdAvatar?.eye, let initalNose = data.initialAdAvatar?.nose, let initialMonth = data.initialAdAvatar?.month {
            ////                self.picker.currentAvatar.eye = initalEye
            ////                self.picker.currentAvatar.nose = initalNose
            ////                self.picker.currentAvatar.month = initialMonth
            //
            //            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.colorPicker.reloadData()
    }
    
    @objc private func sliderValueDidChange(_ sender: UIRadiusSlider){
        self.picker.radius = sender.value
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        showAvatarNameAlert()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    private func showAvatarNameAlert(){
        present(AlertManagment.saveAvatarAlert(sucess: { (name) in
            if let image = self.currentAvatarImage, let name = name{
                self.saveAvatar(image: image, withName: name)
            }
        }), animated: true, completion: nil)
    }
    
    private func saveAvatar(image: UIImage, withName name: String) {
        if CoreDataWrapper.getAvatar(withName: name) != nil {
            self.present(AlertManagment.saveAvatarErrorAlert(name: name), animated: true, completion: nil)
            return
        }
        
        if let roundedImage = image.radiusImage(radius: (image.size.width/2) * CGFloat(self.radiusSlider.value)) {
            FileManager.default.saveAvatarImage(roundedImage, withName: name)
        } else {
            FileManager.default.saveAvatarImage(image, withName: name)
        }
        
        let avatar = Avatar.init(name: name, isFave: false)
        CoreDataStack.saveContext()
        
        dismiss(animated: true) {
            self.delegate?.avatarWasCreated(controller: self, avatar: avatar)
        }
    }
}

extension CreateAvatarViewController: ADAvatarDelegate, ADTypesDelegate {
    func didLoadAvatarImage(wrapper: ADWrapper, image: UIImage) {
        self.picker.image.image = image
        self.picker.image.layer.opacity = 1
        self.currentAvatarImage = image
        
        self.colorPicker.isEnabled = true
        self.picker.isEnabled = true
        
        picker.stopLoading()
    }
    
    func avatarLoadDidFail(wrapper: ADWrapper, for avatar: ADAvatar) {
        self.present(AlertManagment.networkErrorWithCancelAlert(completion: { (retryTapped) in
            if retryTapped {
                self.picker.startLoading()
                self.picker.isEnabled = false
                self.colorPicker.isEnabled = false
                ADWrapper.shared.getAvatarImage(for: self.avatar)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }), animated: true, completion: nil)
        
        self.picker.stopLoading()
    }
    
    func avatarTypesLoadDidFail(wrapper: ADWrapper) {
        self.present(AlertManagment.networkErrorAlert {
            self.loadIndicator.startAnimating()
            ADWrapper.shared.findTypes()
        }, animated: true, completion: nil)
        self.loadIndicator.stopAnimating()
    }
    
    func didLoadAvatarTypes(wrapper: ADWrapper) {
        setupAvatarWithTypes(wrapper: wrapper)
    }
    
    func setupAvatarWithTypes(wrapper: ADWrapper) {
        if let firstAvatarCombination = wrapper.combination(at: 0, withColor: plistReader.colors[0]) {
            
            guard let action = self.action as? CreateAvatarViewControllerAction, action == .push else {
                
                self.avatar = firstAvatarCombination
                
                picker.startLoading()
                self.picker.isEnabled = false
                self.colorPicker.isEnabled = false
                ADWrapper.shared.getAvatarImage(for: avatar)
                loadIndicator.stopAnimating()
                return
            }
            picker.startLoading()
            self.picker.isEnabled = false
            self.colorPicker.isEnabled = false
            ADWrapper.shared.getAvatarImage(for: avatar)
            loadIndicator.stopAnimating()
        }
    }
}

extension CreateAvatarViewController: APAvatarPickerDelegate {
    func nextTapped(_ picker: UIAvatarPicker, inPart avatarComponent: APAvatarComponents, toNumber number: Int) {
        switch avatarComponent {
        case .eye:
            if let eye = ADWrapper.shared.components?.eyesNumbers[number] {
                avatar.eye = eye
            }
        case .month:
            if let month = ADWrapper.shared.components?.mouthsNumbers[number] {
                avatar.month = month
            }
        case .nose:
            if let nose = ADWrapper.shared.components?.noseNumbers[number] {
                avatar.nose = nose
            }
        }
        picker.image.image = picker.image.image?.blurImage(force: 5)
        picker.image.layer.opacity = 0.5
        
        picker.startLoading()
        self.picker.isEnabled = false
        self.colorPicker.isEnabled = false
        ADWrapper.shared.getAvatarImage(for: avatar)
    }
    
    func prevTapped(_ picker: UIAvatarPicker, inPart avatarComponent: APAvatarComponents, toNumber number: Int) {
        switch avatarComponent {
        case .eye:
            if let eye = ADWrapper.shared.components?.eyesNumbers[number] {
                avatar.eye = eye
            }
        case .month:
            if let month = ADWrapper.shared.components?.mouthsNumbers[number] {
                avatar.month = month
            }
        case .nose:
            if let nose = ADWrapper.shared.components?.noseNumbers[number] {
                avatar.nose = nose
            }
        }
        picker.image.image = picker.image.image?.blurImage(force: 5)
        picker.image.layer.opacity = 0.5
        
        picker.startLoading()
        self.picker.isEnabled = false
        self.colorPicker.isEnabled = false
        ADWrapper.shared.getAvatarImage(for: avatar)
    }
}

extension CreateAvatarViewController: APAvatarPickerDatasource {
    func initialValue(picker: UIAvatarPicker, forComponent component: APAvatarComponents) -> Int {
        return 0
    }
    
    func numberOfTypes(picker: UIAvatarPicker, forComponent component: APAvatarComponents) -> Int {
        switch component {
        case .eye:
            return ADWrapper.shared.components?.eyes.count ?? 0
        case .nose:
            return ADWrapper.shared.components?.noses.count ?? 0
        case .month:
            return ADWrapper.shared.components?.mouths.count ?? 0
        }
    }
}

extension CreateAvatarViewController: UIColorPickerDatasource, UIColorPickerDelegate {
    func numberOfVariationsPerColor(_ colorPicker: UIColorPicker) -> Int {
        return 4
    }
    
    func responsibleController(_ colorPicker: UIColorPicker) -> UIViewController {
        return self
    }
    
    func sizeForColorViews(colorPicker: UIColorPicker) -> CGSize {

        var size: CGSize?
        
        if self.view.isStanding() {
            let width = self.colorPickerContainer.frame.height - 48
            let height = width
            
            size = CGSize.init(width: width, height: height)
        } else {
            let width = (self.colorPickerContainer.frame.height - 48)/2
            let height = width
            
            size = CGSize.init(width: width, height: height)
        }
        
        return size!
    }
    
    func numberOfColors(colorPicker: UIColorPicker) -> Int {
        return self.pickerColors?.count ?? 0
    }
    
    func colorForPosition(colorPicker: UIColorPicker, position: Int) -> PickerColor? {
        return self.pickerColors?[position]
    }
    
    func initialColor(colorPicker: UIColorPicker) -> Int {
        return 0
    }
    
    func imageForSelectColor(colorPicker: UIColorPicker) -> UIImage? {
        return UIImage.init(named: This.colorPickerImageCheckName)
    }
    
    func colorWasSelected(_ colorPicker: UIColorPicker, atPosition position: Int) {
        self.avatar.color = pickerColors?[position].color
        
        picker.image.image = picker.image.image?.blurImage(force: 5)
        picker.image.layer.opacity = 0.5
        
        picker.startLoading()
        self.picker.isEnabled = false
        self.colorPicker.isEnabled = false
        ADWrapper.shared.getAvatarImage(for: avatar)
    }
}

extension CreateAvatarViewController {
    
    enum Strings: String, Localizable {
        case controller_createAvatar_title
    }
}
