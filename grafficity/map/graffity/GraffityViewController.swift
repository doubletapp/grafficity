//
//  GraffityViewController.swift
//  Grafficity
//
//  Created by Hash on 10/11/2018.
//  Copyright © 2018 doubletapp. All rights reserved.
//

import Foundation
import UIKit

class GraffityViewController: UIViewController {
    
    var record: GraffityRecord!
	
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var authorTitle: UILabel!
    @IBOutlet weak var graffityTitle: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var checkinLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var backArrow: UIImageView! {
        didSet{
            let tapRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(didTapBack))
            backArrow.isUserInteractionEnabled = true
            backArrow.addGestureRecognizer(tapRecognizer)
        }
    }
    @IBOutlet weak var otherWorks: UICollectionView! {
        didSet {
            otherWorks.dataSource = self
        }
    }
    
    @IBOutlet weak var descView: UIView! {
        didSet {
            descView.layer.shadowColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 0.15).cgColor
            descView.layer.shadowOffset = CGSize(width: 0, height: 10)
            descView.layer.shadowRadius = 10.0
            descView.layer.shadowOpacity = 1.0
        }
    }
    
    override func viewDidLoad() {
        graffityTitle.text = record.name
        authorTitle.text = record.artist
        previewImage.image = record.preview
        ratingLabel.text = "\(Int.random(in: 1...999))"
        checkinLabel.text = "\(Int.random(in: 0...250))"
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    @objc func didTapBack() {
        self.dismiss(animated: true)
    }
}

extension GraffityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherWorkCell", for: indexPath)
        (cell as? OtherWorkCellView)?.imageView.image = UIImage(named: "graffity\(Int.random(in: 0...12))")
        return cell
    }
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}

class OtherWorkCellView: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
}
