import Foundation
import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
        let initialLocation = CLLocationCoordinate2D(latitude: 59.939044, longitude: 30.315888)
    
    @IBOutlet weak var displayLocationButton: UIButton!
    @IBOutlet weak var switchModeButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.setImage(UIImage(named: "search"), for: .search, state: .normal)
            searchBar.setSearchFieldBackgroundImage(UIImage(named: "searchBackground"),for: .normal)
            searchBar.layer.cornerRadius = 26.5
            searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 11.0, vertical: 0)
            searchBar.setPositionAdjustment(UIOffset(horizontal: 19.0, vertical: 0.0), for: .search)
        }
    }
    
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.animate(toLocation: initialLocation)
            mapView.isMyLocationEnabled = true
            setupMapStyle(mapView)
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation? {
        willSet(value) {
            if currentLocation == nil, let coordinate = value?.coordinate {
                moveCamera(to: coordinate, zoom: 17.0)
            }
        }
    }
    
    override func viewDidLoad() {
        initializeLocation()
        seedMarkers()
    }
    
    
    @IBAction func didTapDisplayLocation(_ sender: Any) {
    }
    
    @IBAction func didTapSwitchMode(_ sender: Any) {
    }
    
    
    private func setupMapStyle(_ map: GMSMapView) {
        do {
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                map.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find MapStyle.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    private func initializeLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    private func initializeSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = ""
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func seedMarkers() {
        mapView.clear()
        let records = ModelGenerator.generateGraffities()
        for record in records {
        	let marker = GMSMarker(position: record.location!)
            marker.title = record.name
            marker.map = mapView
            if record.rating < 0.5 {
                marker.icon = UIImage(named: "mapPin")
            } else {
                let icon = UIImage.getPreviewMarker(
                    	with: record.preview,
                        size: CGFloat(36 + (record.rating - 0.5) * 44))
                let previewMarker = PreviewMarker(frame: CGRect(
                    origin: .zero,
                    size: CGSize(width: icon!.size.width, height: icon!.size.height + 24)
                ))
                previewMarker.preview.image = icon
                marker.iconView = previewMarker
            }
        }
    }
    
    private func moveCamera(to location: CLLocationCoordinate2D) {
        let update = GMSCameraUpdate.setTarget(location)
        mapView.moveCamera(update)
    }
    
    private func moveCamera(to location: CLLocationCoordinate2D, zoom: Float) {
        let update = GMSCameraUpdate.setTarget(location, zoom: zoom)
        mapView.moveCamera(update)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.currentLocation = location
    }
}

extension MapViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
    }
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MapViewController: UISearchControllerDelegate {
}

extension MapViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.25, animations: {
            self.filterButton.alpha = 0.0
        }, completion: { completed in
            self.filterButton.isHidden = true
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.25) {
        	self.filterButton.isHidden = false
            self.filterButton.alpha = 1.0
        }
    }
}
