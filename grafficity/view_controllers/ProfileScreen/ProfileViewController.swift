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
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cellDescriptions.append(CollectionViewCellDescription(cellType: ProfileHeaderCell.self, object: nil))

        collectionView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

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

//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row == 0 {
//            return CGSize(width: UIScreen.main.bounds.width, height: 300)
//        }
//        return CGSize(width: 0, height: 0)
//    }
}
