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
import GoogleMaps

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
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: 59.9315, longitude: 30.2830))
        path.add(CLLocationCoordinate2D(latitude: 59.9487, longitude: 30.3484))
        path.add(CLLocationCoordinate2D(latitude: 59.9149, longitude: 30.3360))
        
        for i in 0...12 {
            let record = GraffityRecord(
                artist: artists[i],
                name: artworks[i])
            var latitude = 0.0
            var longitude = 0.0
            while (!GMSGeometryContainsLocation(
                	CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                	path,
                    true)) {
                latitude = Double.random(in: 59.9315...59.9487)
                longitude = Double.random(in: 30.2830...30.3360)
            }
            
            record.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            record.preview = UIImage(named: "graffity\(i)")
            record.rating = Double.random(in: 0.0...1.0)
            records.append(record)
        }
        
        return records
    }
}
