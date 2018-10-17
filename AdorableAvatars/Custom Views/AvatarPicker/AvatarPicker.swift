//
//  AvatarPicker.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 16/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class AvatarPicker: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nextEyeButton: UIButton!
    @IBOutlet weak var nextNoseButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    
    @IBOutlet weak var prevEyeButton: UIButton!
    @IBOutlet weak var prevMonthButton: UIButton!
    @IBOutlet weak var prevNoseButton: UIButton!
    
    var delegate: AvatarPickerDelegate?
    var datasource: AvatarPickerDatasource?
    var currentAvatar = Avatar.init(eye: 0, nose: 0, month: 0)
    
    private lazy var loadIndicator: UIActivityIndicatorView = {
        let loadIndicator = UIActivityIndicatorView.init()
        loadIndicator.frame.size = image.frame.size
        loadIndicator.frame.origin = CGPoint.init(x: 0, y: 0)
        loadIndicator.color = UIColor.white
        loadIndicator.hidesWhenStopped = true
        image.addSubview(loadIndicator)
        
        return loadIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    private func initCommon(){
        Bundle.main.loadNibNamed("AvatarPicker", owner: self, options: nil)
        addSubview(containerView)
        
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    public func startLoading(){
        loadIndicator.startAnimating()
    }
    
    public func stopLoading(){
        loadIndicator.stopAnimating()
    }
    
    private func applyTopLimit(for nextbutton: UIButton, and prevButton: UIButton, inComponent component: AvatarComponents, completion: () -> ()) {
        guard let datasource = self.datasource else {
            return
        }
        
        completion()
        
        if self.currentAvatar.value(for: component) == datasource.numberOfTypes(picker: self, forComponent: component) - 1{
            nextbutton.isEnabled = false
        } else if self.currentAvatar.value(for: component) == 1 {
            prevButton.isEnabled = true
        }
        
    }
    
    private func applyBottomLimit(for nextButton: UIButton, and prevButton: UIButton, inComponent component: AvatarComponents, completion: () -> ()) {
        guard let datasource = self.datasource else {
            return
        }
        
        completion()
        
        if self.currentAvatar.value(for: component) == (datasource.numberOfTypes(picker: self, forComponent: component) - 2) {
            nextButton.isEnabled = true
        } else if self.currentAvatar.value(for: component) == 0 {
            prevButton.isEnabled = false
        }
    }
   
    @IBAction func nextEyesTapped(_ sender: UIButton) {
        applyTopLimit(for: sender, and: prevEyeButton, inComponent: AvatarComponents.eye){
            self.currentAvatar.eye += 1
            delegate?.nextTapped(self, inPart: AvatarComponents.eye, toNumber: self.currentAvatar.eye)
        }
    }
    
    @IBAction func nextNoseTapped(_ sender: UIButton) {
        applyTopLimit(for: sender, and: prevNoseButton, inComponent: AvatarComponents.nose){
            self.currentAvatar.nose += 1
            delegate?.nextTapped(self, inPart: AvatarComponents.nose, toNumber: self.currentAvatar.nose)
        }
    }
    
    @IBAction func nextMonthButton(_ sender: UIButton) {
        applyTopLimit(for: sender, and: prevMonthButton, inComponent: AvatarComponents.month){
            self.currentAvatar.month += 1
            delegate?.nextTapped(self, inPart: AvatarComponents.month, toNumber: self.currentAvatar.month)
        }
    }
    
    @IBAction func prevEyeTapped(_ sender: UIButton) {
        applyBottomLimit(for: nextEyeButton, and: sender, inComponent: AvatarComponents.eye){
            self.currentAvatar.eye -= 1
            delegate?.prevTapped(self, inPart: AvatarComponents.eye, toNumber: currentAvatar.eye)
        }
    }
    @IBAction func prevNoseTapped(_ sender: UIButton) {
        applyBottomLimit(for: nextNoseButton, and: sender, inComponent: AvatarComponents.nose){
            self.currentAvatar.nose -= 1
            delegate?.prevTapped(self, inPart: AvatarComponents.nose, toNumber: currentAvatar.nose)
        }
    }
    @IBAction func prevMonthTapped(_ sender: UIButton) {
        applyBottomLimit(for: nextMonthButton, and: sender, inComponent: AvatarComponents.month){
            self.currentAvatar.month -= 1
            delegate?.prevTapped(self, inPart: AvatarComponents.month, toNumber: currentAvatar.month)
        }
    }
}
