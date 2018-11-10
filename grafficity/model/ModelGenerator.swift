//
//  ModelGenerator.swift
//  Grafficity
//
//  Created by Hash on 10/11/2018.
//  Copyright © 2018 doubletapp. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ModelGenerator {
    
    class func generateGraffities() -> [GraffityRecord] {
        var records: [GraffityRecord] = []
        
        for i in 0...15 {
            let record = GraffityRecord(
                artist: "Artist \(i % 8)",
                name: "Picture \(i)")
            let latitude = Double.random(in: 59.925467...59.946543)
            let longitude = Double.random(in: 30.301036...30.326785)
            record.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            record.preview = UIImage(named: "sampleGraffity\(i % 8)")
            record.rating = Double.random(in: 0.0...1.0)
            records.append(record)
        }
        
        return records
    }
}
