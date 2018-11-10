import Foundation
import ARKit

class ARPreviewMarker: BaseView {

    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!

    override func layoutSubviews() {
        super.layoutSubviews()

        bottomSpaceConstraint.constant = 24 + (view.superview?.layoutMargins.bottom ?? 0)
    }
}
