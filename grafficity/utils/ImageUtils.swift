//
//  ImageViewUtils.swift
//  Grafficity
//
//  Created by Hash on 09/11/2018.
//  Copyright © 2018 doubletapp. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    class func getMarker(with logoImage: UIImage? ) -> UIImage? {
        
        guard let logoImage = logoImage else {
            return UIImage(named: "defaultMarker")
        }
        
        guard let markerImage = UIImage(named: "defaultMarker") else { return nil }
        
        let roundedLogo = UIImage.maskRoundedImage(image: logoImage, sideLength: min(logoImage.size.width, logoImage.size.height))
        
        let newSize = markerImage.size // set this to what you need
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        roundedLogo.draw(in: CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: 43, height: 43)))
        markerImage.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func getPreviewMarker(with logoImage: UIImage?, size: CGFloat) -> UIImage? {
        
        guard let logoImage = logoImage else {
            return UIImage(named: "mapPin")
        }
        
        let sideLength = min(logoImage.size.width, logoImage.size.height)
        let roundedLogo = UIImage.maskRoundedImage(image: logoImage, sideLength: sideLength)
        
        let newSize = CGSize(width: size, height: size) // set this to what you need
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        ctx.setFillColor(UIColor.white.cgColor)
        
        
        ctx.fillEllipse(in: CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size)))
        roundedLogo.draw(in: CGRect(origin: CGPoint(x: 2.5, y: 2.5), size: CGSize(width: size - 5, height: size - 5)))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    class func maskRoundedImage(image: UIImage, sideLength: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: sideLength, height: sideLength))
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: sideLength, height: sideLength)))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let newImageView = UIImageView(image: croppedImage)
        let layer = newImageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = sideLength / 2
        UIGraphicsBeginImageContext(CGSize(width: sideLength, height: sideLength))
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return roundedImage!
    }
}

class MyImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
}
