import Foundation
import UIKit

struct FeedBottomViewCellObject {
    let count: Int
    let selected: Bool
    let image: UIImage
}

class FeedBottomViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            shadowView.layer.shadowOffset = CGSize(width: 0 , height: 10)
            shadowView.layer.shadowOpacity = 1.0
            shadowView.layer.shadowRadius = 10.0
            shadowView.layer.shadowColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 0.15).cgColor
        }
    }
    @IBOutlet weak var templateView: UIView! {
        didSet {
            templateView.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowView.layer.cornerRadius = 5.0
    }
}

extension FeedBottomViewCell: BaseCollectionViewCell {
    
    func configure(for object: Any?) {
        guard let object = object as? FeedBottomViewCellObject else { return }
        
        countLabel.text = "\(object.count)"
        imageView.image = object.image
        selectedView.image = #imageLiteral(resourceName: "star")
    }
}
