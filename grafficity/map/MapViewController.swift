import Foundation
import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    
        let initialLocation = CLLocationCoordinate2D(latitude: 59.939044, longitude: 30.315888)
    
    @IBOutlet weak var displayLocationButton: UIButton!
    @IBOutlet weak var switchModeButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    @IBOutlet weak var markersSetSwitch: UISegmentedControl! {
        didSet {
            markersSetSwitch.layer.cornerRadius = 20
            markersSetSwitch.layer.borderColor = UIColor.interfaceAccentColor.cgColor
            markersSetSwitch.layer.borderWidth = 1.0
            markersSetSwitch.layer.masksToBounds = true
            
            markersSetSwitch.addTarget(self, action: #selector(didTapMarkersSwitch), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var bottomSheetTopOffestConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            let edgePanGesture = UIPanGestureRecognizer(target: self, action: #selector(showBottomSheetAction(sender:)))
            bottomView.addGestureRecognizer(edgePanGesture)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openSelectedGraffity))
            bottomView.addGestureRecognizer(tapGesture)
        }
    }
    
    
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
    
    var subscriptions: [GraffityRecord] = []
    var popular: [GraffityRecord] = []
    
    private var bottomSheetExpanded = false
    var selectedGraffity: GraffityRecord?
    
    override func viewDidLoad() {
        initializeLocation()
        seedMarkers()
    }
    
    
    @IBAction func didTapDisplayLocation(_ sender: Any) {
        if let location = currentLocation {
            mapView.animate(toLocation: location.coordinate)
        }
    }
    
    @IBAction func didTapSwitchMode(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            self?.present(ARMapViewController(), animated: true)
        }
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
        subscriptions = ModelGenerator.generateGraffities()
        popular = ModelGenerator.generateGraffities()
        
        setMarkers(subscription: markersSetSwitch.selectedSegmentIndex == 1)
    }
    
    private func setMarkers(subscription: Bool) {
        mapView.clear()
        if subscription {
            displayMarkers(subscriptions)
        } else {
            displayMarkers(popular)
        }
    }
    
    private func displayMarkers(_ records: [GraffityRecord]) {
        for record in records {
            let marker = GMSMarker(position: record.location!)
            marker.title = record.name
            marker.map = mapView
            marker.userData = record
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

// MARK: - GMSMapViewDelegate

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 17.0)
        mapView.animate(to: camera)
        if let record = marker.userData as? GraffityRecord {
            selectedGraffity = record
            prepareBottomSheet(with: record)
        }
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
    
    private func prepareBottomSheet(with record: GraffityRecord) {
        bottomArtist.text = record.artist
        bottomGraffity.text = record.name
        bottomPreview.image = record.preview
        if let current = currentLocation,
            	let lat = record.location?.latitude,
        		let lng = record.location?.longitude {
            let location = CLLocation(latitude: lat, longitude: lng)
            let distance = current.distance(from: location)
            if distance > 1000 {
                bottomDistance.text = String(format: "%.1f км", distance / 1000)
            } else {
                bottomDistance.text = String(format: "%.0f м", distance)
            }
        } else {
            bottomDistance.text = ""
        }
    }
    
    @objc func showBottomSheetAction(sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let y = sender.translation(in: mapView).y
            if y > 0 {
                let height = bottomView.bounds.height
                
                var mapPadding = mapView.padding
                mapPadding.bottom = max(0, height - y)
                mapView.padding = mapPadding
                
                bottomSheetTopOffestConstraint.constant = -(max(0, height - y))
            }
        } else if sender.state == .ended {
            if mapView.padding.bottom < bottomView.bounds.height * 0.7 {
                hideBottomSheet()
            } else {
                showBottomSheet()
            }
        }
    }
    
    @objc func openSelectedGraffity() {
        guard let graffity = selectedGraffity else {
            return
        }
        guard let graffityViewController = UIStoryboard(name: "GraffityView", bundle: nil)
            .instantiateInitialViewController() else { return }
        (graffityViewController as? GraffityViewController)?.record = graffity
        self.present(graffityViewController, animated: true)
    }
}

extension MapViewController {
    
    @objc func didTapMarkersSwitch() {
        if markersSetSwitch.selectedSegmentIndex == 0 {
            setMarkers(subscription: false)
        } else {
            setMarkers(subscription: true)
        }
    }
}
