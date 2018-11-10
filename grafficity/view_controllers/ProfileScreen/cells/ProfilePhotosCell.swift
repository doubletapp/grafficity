import Foundation
import UIKit


class ProfilePhotosCell: UICollectionViewCell {


    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    @IBOutlet weak var imageView: UIImageView!

}

extension ProfilePhotosCell: BaseCollectionViewCell {
    func configure(for object: Any?) {
        widthConstraint.constant = UIScreen.main.bounds.width
    }
}