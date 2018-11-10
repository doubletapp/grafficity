import Foundation
import UIKit

extension UIImage {

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
