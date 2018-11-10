import Foundation
import CoreLocation
import UIKit

class GraffityRecord {
    
    var artist: String
    var name: String
    var location: CLLocationCoordinate2D?
    var preview: UIImage?
    var rating: Double = 0.5
    
    init(artist: String, name: String) {
        self.artist = artist
        self.name = name
    }
    
}
