//
//  ColorPicker.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 17/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import UIKit

class UIColorPicker: UIBaseZibView {
    @IBOutlet var contentView: UIView! {
        didSet {
            super.contentViewZib = contentView
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    public var datasource: UIColorPickerDatasource?
    public var delegate: UIColorPickerDelegate?
    public var isEnabled: Bool = true {
        didSet {
            if self.isEnabled {
                self.isUserInteractionEnabled = true
                self.collectionView.reloadData()
            } else {
                self.isUserInteractionEnabled = false
                self.collectionView.reloadData()
            }
        }
    }
    
    private var firstColorWasSet = false
    private var selectedColor: PickerColor?
    
    override func layoutSubviews() {
        collectionView.register(UINib(nibName: "UIColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "colorCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
    }
    
    public func reloadData() {
        self.collectionView.reloadData()
    }
}

extension UIColorPicker: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    @objc func cellLongPressHappend(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began{
//            if  let indexPath = self.collectionView.indexPathForItem(at: gestureRecognizer.location(in: self.collectionView)),
//                let cell = self.collectionView.cellForItem(at: indexPath) as? UIColorCollectionViewCell{
//                cellLongPressHappend(atCell: cell, atIndexPath: indexPath)
//            }
        }
    }
//
//    func cellLongPressHappend(atCell cell: UIColorCollectionViewCell, atIndexPath indexPath: IndexPath) {
//        let cellCopy = cell.copy()
//        print(cellCopy)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource?.numberOfColors(colorPicker: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
    
        if let colorCell = cell as? UIColorCollectionViewCell, let color = self.datasource?.colorForPosition(colorPicker: self, position: indexPath.item) {

            let image = datasource?.imageForSelectColor(colorPicker: self)
            colorCell.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(self.cellLongPressHappend(_:))))
            colorCell.setup(color: color.color, isSelected: color.isSelected, checkImage: image)
            
            if !self.isEnabled {
                colorCell.layer.opacity = 0.7
            } else {
                colorCell.layer.opacity = 1
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let initialColor = self.datasource?.initialColor(colorPicker: self), !firstColorWasSet, initialColor == indexPath.row {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            
            if let colorCell = cell as? UIColorCollectionViewCell, let color = self.datasource?.colorForPosition(colorPicker: self, position: indexPath.row) {
                colorCell.isSelected = true
                color.isSelected = true
                self.selectedColor = color
            }
    
            firstColorWasSet = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return self.datasource?.sizeForColorViews(colorPicker: self) ?? CGSize.init(width: 50, height: 50)
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        if let colorCell = cell as? UIColorCollectionViewCell,
           let color = self.datasource?.colorForPosition(colorPicker: self, position: indexPath.row),
           color.isSelected == false {
    
            selectedColor?.isSelected = false
            colorCell.isSelected = true
            color.isSelected = true
            delegate?.colorWasSelected(self, atPosition: indexPath.row)
            selectedColor = color
        }
        collectionView.reloadData()
    }

}

