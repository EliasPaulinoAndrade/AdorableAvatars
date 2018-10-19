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
    
    var delegate: AvatarCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gestureTap = UITapGestureRecognizer.init(target: self, action: #selector(self.faveTapped(_:)))
        self.faveImage.addGestureRecognizer(gestureTap)
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
}
