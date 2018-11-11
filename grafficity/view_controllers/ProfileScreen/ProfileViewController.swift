import Foundation
import UIKit

class ProfileViewController: UIViewController {


    var cellDescriptions: [CollectionViewCellDescription] = []


    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.contentInsetAdjustmentBehavior = .never

            (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 1, height: 1)

            collectionView.register(ProfileHeaderCell.self)
            collectionView.register(ProfilePhotosCell.self)
            collectionView.register(ProfileFilterCell.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cellDescriptions.append(CollectionViewCellDescription(cellType: ProfileHeaderCell.self, object: nil))
        cellDescriptions.append(CollectionViewCellDescription(cellType: ProfileFilterCell.self, object: nil))
        cellDescriptions.append(CollectionViewCellDescription(cellType: ProfilePhotosCell.self, object: nil))

        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionView.reloadData()
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellDescriptions.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.configureCell(with: cellDescriptions[indexPath.row], for: indexPath)
    }
}
