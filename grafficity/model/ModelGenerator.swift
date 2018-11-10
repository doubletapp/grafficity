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
    
    private static let artists = [
        "Reyes",
        "Banksy",
        "Revok",
        "Daim",
        "Seak",
        "Shepard Fairey",
        "Saber",
        "Invader",
        "Dondi White",
        "Blek le Rat",
        "Lady Pink",
        "Fourteen Bolt",
        "Laser 3.14"
    ]
    
    private static let artworks = [
        "I Don't Believe In Global Warming",
        "Lets Keep The Plants Alive",
        "World Is Going Down The Drain",
        "The Truth",
        "The Clock Is Ticking",
        "Urbanization Is Killing Us",
        "Animals In Zoos",
        "We're Eating The Earth",
        "I Remember When This Was All Trees",
        "The Earth Is Being Killed",
        "Locked Up Animals",
        "Born To Be Wild",
        "Ice Ice Baby"
    ]
    
    class func generateGraffities() -> [GraffityRecord] {
        var records: [GraffityRecord] = []
        
        for i in 0...12 {
            let record = GraffityRecord(
                artist: artists[i],
                name: artworks[i])
            let latitude = Double.random(in: 59.925467...59.946543)
            let longitude = Double.random(in: 30.301036...30.326785)
            record.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            record.preview = UIImage(named: "graffity\(i)")
            record.rating = Double.random(in: 0.0...1.0)
            records.append(record)
        }
        
        return records
    }
}
