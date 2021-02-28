//
//  ViewController.swift
//  Google-Map
//
//  Created by Summit on 27/02/21.
//

import UIKit
import GoogleMaps
import GooglePlaces

class StartViewController: UIViewController {
    
    // Propoties
    var mapView: GMSMapView!
    var selectedPlace: Place?
    
    @IBOutlet weak var searchBar: UISearchBar!

    
    lazy var locationManager: CLLocationManager = {
         return CLLocationManager()
    }()
    
    // Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performInitialSetUp()
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func performInitialSetUp() {
        setUpMapView()
        configureSearchBar()
    }
    
    private func setUpMapView() {
        let camera = GMSCameraPosition(latitude: 20.593683, longitude: 80.982883, zoom: 4.0)
        mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        view.insertSubview(mapView, at: 0)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func configureSearchBar() {
        searchBar.searchTextField.isUserInteractionEnabled = false
        searchBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapSearchBar(_sender:))))
    }
    
    
    @objc func onTapSearchBar(_sender: UISearchBar) {
        self.performSegue(withIdentifier: "ToPlaceViewController", sender: nil)
    }
    
    @IBAction func renderSelectedPlace(_ sender: UIStoryboardSegue) {
        guard let selectedPlace = selectedPlace else { return }
        mapView.clear()
        let marker = GMSMarker(position: selectedPlace.coordinate)
        marker.map = mapView
        
        let camera = GMSCameraPosition(target: selectedPlace.coordinate, zoom: 10)
        mapView.animate(to: camera)
        
    }
    
}

