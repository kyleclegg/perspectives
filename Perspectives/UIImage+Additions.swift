//
//  Image.swift
//  Perspectives
//
//  Created by Kyle Clegg on 11/11/15.
//  Copyright © 2015 Kyle Clegg. All rights reserved.
//

import UIKit

extension UIImage {

    func resizeImageWithAspectFit(image:UIImage, size:CGSize) -> UIImage {
        let aspectFitSize = self.aspectFitRect(origin: image.size, destination: size)
        let resizedImage = self.resizeImage(image, size: aspectFitSize)
        return resizedImage
    }
    
    func aspectFitRect(origin src:CGSize, destination dst:CGSize) -> CGSize {
        var result = CGSizeZero
        var scaleRatio = CGPoint()
        
        if (dst.width != 0) {scaleRatio.x = src.width / dst.width}
        if (dst.height != 0) {scaleRatio.y = src.height / dst.height}
        let scaleFactor = max(scaleRatio.x, scaleRatio.y)
        
        result.width  = scaleRatio.x * dst.width / scaleFactor
        result.height = scaleRatio.y * dst.height / scaleFactor
        return result
    }
    
    func resizeImage(image:UIImage, size:CGSize) -> UIImage {
        let scale     = UIScreen.mainScreen().scale
        let size      = scale > 1 ? CGSizeMake(size.width/scale, size.height/scale) : size
        let imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale);
        image.drawInRect(imageRect)
        let scaled = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaled;
    }
    
}
