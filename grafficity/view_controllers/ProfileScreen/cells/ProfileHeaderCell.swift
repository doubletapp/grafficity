import Foundation
import UIKit

class ProfileHeaderCell: UICollectionViewCell {

    @IBOutlet var underlines: [UIView]!
    @IBOutlet weak var cellContainer: UIView! {
        didSet {
            cellContainer.layer.masksToBounds = false;
            cellContainer.layer.shadowRadius = 9
            cellContainer.layer.shadowOpacity = 0.1
            cellContainer.layer.shadowColor = UIColor.black.cgColor
            cellContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    @IBOutlet weak var avatarImageVIew: UIImageView! {
        didSet {
            avatarImageVIew.clipsToBounds = true
            avatarImageVIew.layer.cornerRadius = 54
        }
    }

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        underlines.forEach { $0.isHidden = true }
        showUnderline(at: 0)
    }

    @IBAction func didSelectFirstButton() {
        showUnderline(at: 0)
    }

    @IBAction func didSelectSecondButton() {
        showUnderline(at: 1)
    }

    @IBAction func didSelectThirdButton() {
        showUnderline(at: 2)
    }

    private func showUnderline(at index: Int) {
        for (i, underline) in underlines.enumerated() {
            underline.isHidden = i != index
        }
    }
}

extension ProfileHeaderCell: BaseCollectionViewCell {

    func configure(for object: Any?) {
        widthConstraint.constant = UIScreen.main.bounds.width
    }
}
