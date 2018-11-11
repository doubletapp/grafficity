import Foundation
import ARKit

class ARPreviewMarker: BaseView {

    @IBOutlet weak var bottomSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()

        bottomSpaceConstraint.constant = 24 + (view.superview?.layoutMargins.bottom ?? 0)
    }

    func updateRandomData() {
        let models = ModelGenerator.generateGraffities()
        
        let generatedModel = models[Int.random(in: 0..<models.count)]

        nameLabel.text = generatedModel.artist
        titleLabel.text = generatedModel.name
        coverImage.image = generatedModel.preview
    }
}
