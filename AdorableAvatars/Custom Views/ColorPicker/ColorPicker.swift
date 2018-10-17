//
//  ColorPicker.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class ColorPicker: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var datasource: ColorPickerDatasource?
    var delegate: ColorPickerDelegate?
    var colors: [UIColor]?
    
    override func layoutSubviews() {
        collectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "colorCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    private func initCommon(){
        Bundle.main.loadNibNamed("ColorPicker", owner: self, options: nil)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension ColorPicker: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return colors?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
    
        if let colorCell = cell as? ColorCollectionViewCell, let color = colors?[indexPath.row] {
            
            colorCell.backgroundColor = color
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        return CGSize.init(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let colorCell = cell as? ColorCollectionViewCell{
            
            colorCell.checkImage.isHidden = false
            colorCell.checkImage.image = datasource?.imageForSelectColor(colorPicker: self)
            delegate?.colorWasSelected(self, atPosition: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if let colorCell = cell as? ColorCollectionViewCell{
            colorCell.checkImage.isHidden = true
        }
    }
}

