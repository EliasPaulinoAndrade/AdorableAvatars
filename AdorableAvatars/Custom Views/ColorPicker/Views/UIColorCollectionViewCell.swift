//
//  MyCollectionViewCell.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class UIColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainColorView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var shadowColorView: UIView!
    
    public override var isSelected: Bool {
        didSet {
            if isSelected {
                checkImage.isHidden = false
            } else {
                checkImage.isHidden = true
            }
        }
    }
    
    func setup(color: UIColor, checkImage: UIImage?, isSelected selected: Bool = false, showShadowView: Bool = true, showDropShadow: Bool = false) {
        self.mainColorView.backgroundColor = color
        self.shadowColorView.backgroundColor = color
        shadowColorView.layer.opacity = showShadowView ? 0.3 : 0
        if showDropShadow {
            mainColorView.layer.masksToBounds = false
            mainColorView.layer.shadowColor = UIColor.black.cgColor
            mainColorView.layer.shadowOpacity = 0.8
            mainColorView.layer.shadowRadius = 5
        }
        self.checkImage.image = checkImage
        self.isSelected = selected
    }
    
    override func awakeFromNib() {
        self.mainColorView.layer.cornerRadius = 5
        self.shadowColorView.layer.cornerRadius = 5
        
    }
}
