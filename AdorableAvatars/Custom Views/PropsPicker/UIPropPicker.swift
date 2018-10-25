//
//  UIPropPicker.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 25/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class UIPropPicker: UIBaseZibView {
    
    @IBOutlet var contentView: UIView! {
        didSet {
            super.contentViewZib = contentView
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
}
