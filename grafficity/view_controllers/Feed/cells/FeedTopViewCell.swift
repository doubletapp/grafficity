import Foundation
import UIKit

struct FeedTopViewCellObject {
    let title: String
    let totalDays: Int
    let numberOfPeople: Int
    let image: UIImage
}

class FeedTopViewCell: UICollectionViewCell {
    
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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leastDaysLabel: UILabel!
    @IBOutlet weak var numberOfPeople: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowView.layer.cornerRadius = 5.0
    }
    
}

extension FeedTopViewCell: BaseCollectionViewCell {
    
    func configure(for object: Any?) {
        guard let object = object as? FeedTopViewCellObject else { return }
        
        imageView.image = object.image
        titleLabel.text = object.title
        leastDaysLabel.text = "Осталось \(object.totalDays) дня"
        numberOfPeople.text = "\(object.numberOfPeople)"
    }
}
