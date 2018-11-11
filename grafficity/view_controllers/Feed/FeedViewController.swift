import Foundation
import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var topCollectionView: UICollectionView! {
        didSet {
            topCollectionView.delegate = self
            topCollectionView.dataSource = self
            topCollectionView.register(FeedTopViewCell.self)
        }
    }
    @IBOutlet weak var bottomCollectionView: UICollectionView! {
        didSet {
            bottomCollectionView.delegate = self
            bottomCollectionView.dataSource = self
            bottomCollectionView.register(FeedBottomViewCell.self)
        }
    }
    
    @IBOutlet weak var filterDateButton: UIButton! {
        didSet {
            setActiveButton(button: filterDateButton)
        }
    }
    @IBOutlet weak var filterPopularityButton: UIButton! {
        didSet {
            setInactiveButton(button: filterPopularityButton)
        }
    }
    
    var cellDescriptions = [CollectionViewCellDescription]()
    var cellDescriptionsTwo = [CollectionViewCellDescription]()
    var cellWidth: CGFloat = 0
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if filterDateButton.frame.width != cellWidth {
            cellWidth = filterDateButton.frame.width
            
            bottomCollectionView.collectionViewLayout.invalidateLayout()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellDescriptions.append(CollectionViewCellDescription(cellType: FeedTopViewCell.self,
                                                              object: FeedTopViewCellObject(title: "Укрась эрмитаж",
                                                                                            totalDays: 42,
                                                                                            numberOfPeople: 109,
                                                                                            image: #imageLiteral(resourceName: "graffity1"))))
        
        cellDescriptions.append(CollectionViewCellDescription(cellType: FeedTopViewCell.self,
                                                              object: FeedTopViewCellObject(title: "Питерская геосходка",
                                                                                            totalDays: 102,
                                                                                            numberOfPeople: 300,
                                                                                            image: #imageLiteral(resourceName: "graffity11"))))
        
        cellDescriptionsTwo.append(CollectionViewCellDescription(cellType: FeedBottomViewCell.self,
                                                                 object: FeedBottomViewCellObject(count: Int.random(in: 1500...2000),
                                                                                                  selected: true,
                                                                                                  image: #imageLiteral(resourceName: "graffity1"))))
        
        cellDescriptionsTwo.append(CollectionViewCellDescription(cellType: FeedBottomViewCell.self,
                                                                 object: FeedBottomViewCellObject(count: Int.random(in: 1500...2000),
                                                                                                  selected: true,
                                                                                                  image: #imageLiteral(resourceName: "graffity1"))))
        
        cellDescriptionsTwo.append(CollectionViewCellDescription(cellType: FeedBottomViewCell.self,
                                                                 object: FeedBottomViewCellObject(count: Int.random(in: 1500...2000),
                                                                                                  selected: true,
                                                                                                  image: #imageLiteral(resourceName: "graffity1"))))
        
        cellDescriptionsTwo.append(CollectionViewCellDescription(cellType: FeedBottomViewCell.self,
                                                                 object: FeedBottomViewCellObject(count: Int.random(in: 1500...2000),
                                                                                                  selected: true,
                                                                                                  image: #imageLiteral(resourceName: "graffity1"))))
        
        cellDescriptionsTwo.append(CollectionViewCellDescription(cellType: FeedBottomViewCell.self,
                                                                 object: FeedBottomViewCellObject(count: Int.random(in: 1500...2000),
                                                                                                  selected: true,
                                                                                                  image: #imageLiteral(resourceName: "graffity1"))))
        
        cellDescriptionsTwo.append(CollectionViewCellDescription(cellType: FeedBottomViewCell.self,
                                                                 object: FeedBottomViewCellObject(count: Int.random(in: 1500...2000),
                                                                                                  selected: true,
                                                                                                  image: #imageLiteral(resourceName: "graffity1"))))
    }
    
    @IBAction func filterDateAction() {
        setActiveButton(button: filterDateButton)
        setInactiveButton(button: filterPopularityButton)
    }
    
    @IBAction func filterPopularityAction() {
        setActiveButton(button: filterPopularityButton)
        setInactiveButton(button: filterDateButton)
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == topCollectionView ? cellDescriptions.count : cellDescriptionsTwo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView == topCollectionView ? collectionView.configureCell(with: cellDescriptions[indexPath.row], for: indexPath) : collectionView.configureCell(with: cellDescriptionsTwo[indexPath.row], for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == topCollectionView ? CGSize(width: 230, height: 150) : CGSize(width: cellWidth, height: 155)
    }
}

extension FeedViewController {
    
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
