//
//  UIViewUtils.swift
//  Grafficity
//
//  Created by Hash on 10/11/2018.
//  Copyright © 2018 doubletapp. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
	func dropShadow(scale: Bool = true) {
    	layer.masksToBounds = false
    	layer.shadowColor = UIColor.black.cgColor
    	layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
    	layer.shadowRadius = 2
    
//        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    	layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
}
