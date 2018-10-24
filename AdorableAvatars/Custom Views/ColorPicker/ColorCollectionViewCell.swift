//
//  MyCollectionViewCell.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
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
    
    func setup(color: UIColor, isSelected selected: Bool = false, checkImage: UIImage?) {
        self.mainColorView.backgroundColor = color
        self.shadowColorView.backgroundColor = color
        self.shadowColorView.layer.opacity = 0.3
        self.checkImage.image = checkImage
        self.isSelected = selected
    }
    
    override func awakeFromNib() {
        self.mainColorView.layer.cornerRadius = 5
        self.shadowColorView.layer.cornerRadius = 5
        
    }
    
    
}
