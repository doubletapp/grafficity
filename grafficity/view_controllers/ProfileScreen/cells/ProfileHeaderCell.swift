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
    @IBOutlet weak var filterDateButton: UIButton!
    @IBOutlet weak var filterPopularityButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        underlines.forEach { $0.isHidden = true }
        showUnderline(at: 0)
        setActiveButton(button: filterDateButton)
        setInactiveButton(button: filterPopularityButton)
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

    @IBAction func filterDateAction() {
        setActiveButton(button: filterDateButton)
        setInactiveButton(button: filterPopularityButton)
    }

    @IBAction func filterPopularityAction() {
        setActiveButton(button: filterPopularityButton)
        setInactiveButton(button: filterDateButton)
    }

    private func showUnderline(at index: Int) {
        for (i, underline) in underlines.enumerated() {
            underline.isHidden = i != index
        }
    }

    private func setActiveButton(button: UIButton) {
        button.backgroundColor = UIColor(netHex: 0xe04a3d)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
    }

    private func setInactiveButton(button: UIButton) {
        button.backgroundColor = UIColor(netHex: 0xf5f5f5)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitleColor(UIColor(netHex: 0x24253d), for: .normal)
    }
}

extension ProfileHeaderCell: BaseCollectionViewCell {

    func configure(for object: Any?) {
        widthConstraint.constant = UIScreen.main.bounds.width
    }
}
