import Foundation
import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
        let initialLocation = CLLocationCoordinate2D(latitude: 59.939044, longitude: 30.315888)
    
    @IBOutlet weak var displayLocationButton: UIButton!
    @IBOutlet weak var switchModeButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var bottomSheetTopOffestConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomPreview: MyImageView!
    @IBOutlet weak var bottomArtist: UILabel!
    @IBOutlet weak var bottomGraffity: UILabel!
    @IBOutlet weak var bottomAddress: UILabel!
    @IBOutlet weak var bottomDistance: UILabel!
    
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
            mapView.delegate = self
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
    
    private var bottomSheetExpanded = false
    
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
                    size: CGSize(width: icon!.size.width, height: icon!.size.height + 22)
                ))
                previewMarker.preview.image = icon
                marker.iconView = previewMarker
                marker.groundAnchor = CGPoint(
                    x: 0.5,
                    y: (icon!.size.height + 11) / (icon!.size.height + 22)
                )
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

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 17.0)
        mapView.animate(to: camera)
        if !bottomSheetExpanded {
			showBottomSheet()
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if bottomSheetExpanded {
        	hideBottomSheet()
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if gesture && bottomSheetExpanded {
        	hideBottomSheet()
    	}
    }
    
    fileprivate func hideBottomSheet() {
        bottomSheetExpanded = false
        
        DispatchQueue.main.async { [weak self] in
            self?.view.setNeedsLayout()
            UIView.animate(withDuration: 0.3) {
                guard let ss = self else { return }
                
                var mapPadding = ss.mapView.padding
                mapPadding.bottom = 0.0
                ss.mapView.padding = mapPadding
                
                ss.bottomSheetTopOffestConstraint.constant = 0
                
                ss.view.setNeedsLayout()
                ss.view.layoutIfNeeded()
            }
        }
    }
    
    private func showBottomSheet() {
        bottomSheetExpanded = true
        
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let ss = self else { return }
            
            var mapPadding = ss.mapView.padding
            mapPadding.bottom = ss.bottomView.bounds.height
            ss.mapView.padding = mapPadding
            
            ss.bottomSheetTopOffestConstraint.constant = -ss.bottomView.bounds.height
            
            ss.view.setNeedsLayout()
            ss.view.layoutIfNeeded()
        }
    }
}
