import Foundation
import UIKit

class ProfileFilterCell: UICollectionViewCell {

    @IBOutlet weak var filterDateButton: UIButton!
    @IBOutlet weak var filterPopularityButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setActiveButton(button: filterDateButton)
        setInactiveButton(button: filterPopularityButton)
    }

    @IBAction func filterDateAction() {
        setActiveButton(button: filterDateButton)
        setInactiveButton(button: filterPopularityButton)
    }

    @IBAction func filterPopularityAction() {
        setActiveButton(button: filterPopularityButton)
        setInactiveButton(button: filterDateButton)
    }

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!

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


extension ProfileFilterCell: BaseCollectionViewCell {
    func configure(for object: Any?) {
        widthConstraint.constant = UIScreen.main.bounds.width
    }
}