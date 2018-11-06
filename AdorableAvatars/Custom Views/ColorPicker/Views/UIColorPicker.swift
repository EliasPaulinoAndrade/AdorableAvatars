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
    private var currentVariations: [UIColorCollectionViewCell]?
    private var overlayView: UIScrollView = UIScrollView.init()
    private var pressingCell: UIColorCollectionViewCell?
    private var currentHoldingVariation: UIColorCollectionViewCell?
    
    
    /*refatorando vars*/
    private var colorVariations: [Int: ColorVariationGroup] = [:]
    private var variationCells: [UIColorCollectionViewCell?]?
    /**/
    
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
        
        let pressLocation = gestureRecognizer.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: pressLocation),
           let cell = self.collectionView.cellForItem(at: indexPath) as? UIColorCollectionViewCell {
         
            if gestureRecognizer.state == .began{
                self.pressingCell = cell
                cellLongPressBeginHappend(atCell: cell, atIndexPath: indexPath)
            } else if gestureRecognizer.state == .ended ||
                      gestureRecognizer.state == .cancelled ||
                      gestureRecognizer.state == .failed {
                cellUserRemovedFinger(atCell: cell)
            }
        }
        else {
            guard let masterView = delegate?.responsibleController(self).view,
                  let pressingCell = self.pressingCell
                  else {
                if gestureRecognizer.state == .ended ||
                   gestureRecognizer.state == .cancelled ||
                   gestureRecognizer.state == .failed {
                    cellUserRemovedFinger(atCell: nil)
                }
                return
            }
            
            let pressLocationInMasterView = self.collectionView.convert(pressLocation, to: masterView)
            
            guard let variationPostition = variationIndex(atPosition: pressLocationInMasterView) else {
                if gestureRecognizer.state == .ended ||
                    gestureRecognizer.state == .cancelled ||
                    gestureRecognizer.state == .failed {
                    cellUserRemovedFinger(atCell: nil)
                }
                return
            }
            
            if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled || gestureRecognizer.state == .failed {
                variationSelected(atPosition: variationPostition)
                cellUserRemovedFinger(atCell: pressingCell)
            } else if gestureRecognizer.state == .changed {
                if let variation = self.currentVariations?[variationPostition] {
                    self.currentHoldingVariation?.layer.borderWidth = 0
                    variation.layer.borderWidth = 2
                    variation.layer.borderColor = UIColor.white.cgColor
                    variation.layer.cornerRadius = 10
                    self.currentHoldingVariation = variation
                }
            }
        }
    }
    
    func variationSelected(atPosition position: Int) {
        
    }
    
    func variationIndex(atPosition position: CGPoint) -> Int? {
        guard let variations = self.currentVariations,
              let masterView = delegate?.responsibleController(self).view
              else {
            return nil
        }
        
        var variationIndex: Int?
        for (index, variation) in variations.enumerated() {
            let cellFrameInMaster = variation.convert(variation.bounds, to: masterView)
            if cellFrameInMaster.contains(position) {
                variationIndex = index
            }
        }
        return variationIndex
    }
    
    func cellUserRemovedFinger(atCell cell: UIColorCollectionViewCell?) {
        
        self.overlayView.removeFromSuperview()
        self.overlayView = UIScrollView.init()
        
        self.currentVariations = nil
    }

    func cellLongPressBeginHappend(atCell cell: UIColorCollectionViewCell, atIndexPath indexPath: IndexPath) {
        guard let masterView = delegate?.responsibleController(self).view else {
            return
        }
        
        let frameInMaster = cell.convert(cell.bounds, to: masterView)
        
        overlayView.frame = masterView.frame
        let variationsContainerView = UIView.init(frame: masterView.frame)
        let backgroundView = UIView.init(frame: masterView.frame)
        
        backgroundView.backgroundColor = UIColor.black
        backgroundView.layer.opacity = 0.7
        
        overlayView.addSubview(backgroundView)
        overlayView.addSubview(variationsContainerView)
        masterView.addSubview(overlayView)
        
        showSubColorOptions(forCell: cell, atIndexPath: indexPath, withFrame: frameInMaster, inView: variationsContainerView)
    }
    
    private func showSubColorOptions(forCell cell: UIColorCollectionViewCell, atIndexPath indexPath: IndexPath, withFrame frame: CGRect, inView view: UIView) {
        
        guard let numberOfVariations = delegate?.numberOfVariationsPerColor(self),
              let colorVariationGroup = self.colorVariations[indexPath.row] else {
                return
        }
        let colorVariations = colorVariationGroup.variations
        
        let prevVariations = colorVariationGroup.mainColorPosition
        var currentYOrigin = frame.origin.y - frame.height * CGFloat(prevVariations)
        
        let variationCells = dequeueVariationCells(numberOfVariations: numberOfVariations, forIndexPath: indexPath)
        guard let colorCellHeight = variationCells.first??.frame.height else {
            return
        }
        
        for variationIndex in 0..<prevVariations {
            currentYOrigin = showSubColor(variationIndex: variationIndex,
                                          colorIndex: variationIndex,
                                          initialYOrigin: currentYOrigin,
                                          colorVariations: colorVariations,
                                          cellVariations: variationCells,
                                          masterView: view,
                                          baseFrame: frame)
        }
        if let mainColorVariationCell = variationCells[prevVariations] {
            showSubColor(initialYOrigin: currentYOrigin,
                         colorVariation: colorVariationGroup.mainColor,
                         cellVariations: mainColorVariationCell,
                         masterView: view,
                         baseFrame: frame)
            currentYOrigin += colorCellHeight
        }
        for variationIndex in (prevVariations + 1)...numberOfVariations {
            currentYOrigin = showSubColor(variationIndex: variationIndex,
                                          colorIndex: variationIndex - 1,
                                          initialYOrigin: currentYOrigin,
                                          colorVariations: colorVariations,
                                          cellVariations: variationCells,
                                          masterView: view,
                                          baseFrame: frame)
        }
    }
    
    func showSubColor(variationIndex: Int, colorIndex: Int, initialYOrigin: CGFloat, colorVariations: [PickerColor], cellVariations: [UIColorCollectionViewCell?], masterView: UIView, baseFrame: CGRect) -> CGFloat {
        if let colorCell = cellVariations[variationIndex] {
            let currentColor = colorVariations[colorIndex]
           
            showSubColor(initialYOrigin: initialYOrigin, colorVariation: currentColor, cellVariations: colorCell, masterView: masterView, baseFrame: baseFrame)
            
            return initialYOrigin + colorCell.frame.height
        }
        return initialYOrigin
    }
    
    func showSubColor(initialYOrigin: CGFloat, colorVariation: PickerColor, cellVariations: UIColorCollectionViewCell, masterView: UIView, baseFrame: CGRect) {
        cellVariations.setup(color: colorVariation.color, checkImage: nil, showShadowView: false)
        
        let currentOrigin = CGPoint.init(x: baseFrame.origin.x, y: initialYOrigin)
        cellVariations.frame = CGRect(origin: baseFrame.origin, size: baseFrame.size)
        
        UIView.animate(withDuration: 0.3) {
            cellVariations.frame.origin = currentOrigin
        }
        
        masterView.addSubview(cellVariations)
        currentVariations?.append(cellVariations)
    }
    
    func dequeueVariationCells(numberOfVariations: Int, forIndexPath indexPath: IndexPath) -> [UIColorCollectionViewCell?]{
        if variationCells == nil {
            self.variationCells = (0..<(numberOfVariations + 1)).map { (_) -> UIColorCollectionViewCell? in
                return self.collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? UIColorCollectionViewCell
            }
        }
        
        return variationCells!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource?.numberOfColors(colorPicker: self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
    
        if  let colorCell = cell as? UIColorCollectionViewCell,
            let color = self.datasource?.colorForPosition(colorPicker: self, position: indexPath.item),
            let numberOfVariations = self.delegate?.numberOfVariationsPerColor(self){

            let image = datasource?.imageForSelectColor(colorPicker: self)
            colorCell.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(self.cellLongPressHappend(_:))))
            colorCell.setup(color: color.color, isSelected: color.isSelected, checkImage: image)
            
            let colorVariation = ColorVariationGroup(mainColor: color, withNumberOfVariations: numberOfVariations)
            self.colorVariations[indexPath.row] = colorVariation
            
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

