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
    
    override func viewDidLoad() {
        graffityTitle.text = record.name
        authorTitle.text = record.artist
        previewImage.image = record.preview
        ratingLabel.text = "\(Int.random(in: 1...999))"
        checkinLabel.text = "\(Int.random(in: 0...250))"
    }
    
    @objc func didTapBack() {
        self.dismiss(animated: true)
    }
}
