//
//  PreviewMarker.swift
//  Grafficity
//
//  Created by Hash on 10/11/2018.
//  Copyright © 2018 doubletapp. All rights reserved.
//

import Foundation
import UIKit

class PreviewMarker: BaseView {
    
    var previewFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override init(frame: CGRect) {
        previewFrame = CGRect(
            x: frame.origin.x,
            y: frame.origin.y,
            width: frame.width - 10,
            height: frame.width - 10)
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var preview: UIImageView! {
        didSet {
            preview.layer.shadowPath = UIBezierPath(roundedRect: previewFrame, cornerRadius: previewFrame.size.width / 2).cgPath
            preview.dropShadow()
        }
    }
    
    @IBOutlet weak var pin: UIImageView!
    
}
