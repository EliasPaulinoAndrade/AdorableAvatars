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
    
    public var isSelected_ = false {
        didSet {
            if isSelected_ {
                checkImage.isHidden = false
//                checkImage.image = datasource?.imageForSelectColor(colorPicker: self)
                
            } else {
                checkImage.isHidden = true
            }
        }
    }
    
    func setColor(color: UIColor){
        self.mainColorView.backgroundColor = color
        self.shadowColorView.backgroundColor = color
        self.shadowColorView.layer.opacity = 0.3
    }
    
    override func awakeFromNib() {
        self.mainColorView.layer.cornerRadius = 5
        self.shadowColorView.layer.cornerRadius = 5
    }
}
