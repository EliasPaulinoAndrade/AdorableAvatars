//
//  UIImage+blurImage.swift
//  AdorableAvatars
//
//  Created by Elias Paulino on 24/10/18.
//  Copyright © 2018 Elias Paulino. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func blurImage(force: Int) -> UIImage {
        let context = CIContext.init(options: nil)
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: self)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(force, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        
        
        return processedImage
    }
    
    func radiusImage(radius: CGFloat) -> UIImage? {
        
        let imageView: UIImageView = UIImageView(image: self)
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
}
