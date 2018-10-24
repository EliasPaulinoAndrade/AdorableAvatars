//
//  AvatarCollectionViewCell.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 18/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarName: UILabel!
    @IBOutlet weak var faveImage: UIImageView!
    @IBOutlet weak var closeImage: UIImageView!
    
    var delegate: AvatarCollectionViewCellDelegate?
    
    public var isShaking: Bool? {
        didSet{
            if let isShaking = self.isShaking, isShaking == true {

                self.closeImage.alpha = 1
                self.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
                
                let animation = CABasicAnimation.init(keyPath: "transform.rotation")
                animation.duration = 0.1
                animation.repeatCount = .infinity
                animation.autoreverses = true
                animation.fromValue = 0.02
                animation.toValue = -0.02
                self.layer.removeAnimation(forKey: "avatar_shaking")
                self.layer.add(animation, forKey: "avatar_shaking")
            } else {
                self.closeImage.alpha = 0
                self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                self.layer.removeAnimation(forKey: "avatar_shaking")
            }
        }
    }
    
    public var isFaved: Bool? {
        didSet {
            if let isFaved = self.isFaved{
                if isFaved {
                    self.faveImage.image = UIImage.init(named: "star_fill")
                }
                else {
                    self.faveImage.image = UIImage.init(named: "star")
                }
            }
        }
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
        closeImage.layer.masksToBounds = false
        closeImage.layer.shadowColor = UIColor.black.cgColor
        closeImage.layer.shadowOpacity = 0.5
        closeImage.layer.shadowOffset = CGSize(width: -1, height: 1)
        closeImage.layer.shadowRadius = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gestureStarTap = UITapGestureRecognizer.init(target: self, action: #selector(self.faveTapped(_:)))
        
        let gestureCloseTap = UITapGestureRecognizer.init(target: self, action: #selector(self.closeTapped(_:)))
        
        self.faveImage.addGestureRecognizer(gestureStarTap)
        self.closeImage.addGestureRecognizer(gestureCloseTap)
    }
    
    public func setup(name: String, image: UIImage?, isFaved: Bool, isShaking: Bool){
        self.avatarImage.image = image
        self.avatarName.text = name.capitalized
        
        self.isFaved = isFaved
        self.isShaking = isShaking
    }
    
    @objc private func faveTapped(_ sender: UIImageView){
        if let isFaved = self.isFaved{
            self.isFaved = !isFaved
        }
        delegate?.avatarWasFavorite(self)
    }
    
    public func invert(){
        self.faveImage.image = UIImage.init(named: "star_fill")
    }

    @objc private func closeTapped(_ sender: UIImageView) {
        self.delegate?.avatarWasClosed(self)
    }
}
