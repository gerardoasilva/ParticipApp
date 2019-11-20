//
//  HomeViewController.swift
//  ParticipApp
//
//  Created by Gerardo Silva Razo on 11/12/19.
//  Copyright © 2019 Gerardo Silva Razo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var preferencesButton: UIButton!
    @IBOutlet weak var inboxButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var recompensas: UIButton!
    
    // Variable to know if the side menu is showing
    var menuShowing = false
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    let regionInMeters: Double = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Checks location services
        checkLocationServices()
        
        // HomeView Shadow
        homeView.layer.shadowOpacity = 1
        
        // Radius
        homeView.layer.shadowRadius = 5
        homeView.layer.cornerRadius = 15
        mapView.layer.cornerRadius = 15
        preferencesButton.layer.cornerRadius = 0.5 * preferencesButton.bounds.size.width
        inboxButton.layer.cornerRadius = 0.5 * inboxButton.bounds.size.width
        recompensas.layer.cornerRadius = 15
        
    }
    
    // Updates constraints of homeView and menuView when button pressed
    @IBAction func openMenu(_ sender: Any) {
        if menuShowing { // Hides menu
            
            //homeLeadingConstraint.constant = 0
            menuLeadingConstraint.constant = -375
            homeButton.isEnabled = false
            homeButton.alpha = 0
        } else { // Shows menu
            
            //homeLeadingConstraint.constant = 240
            menuLeadingConstraint.constant = 0
            menuButton.isEnabled = false
            menuButton.tintColor = UIColor.clear
            
            
            
            
        }
        // Menu slide animation
        UIView.animate(withDuration: 0.15, animations: {
            self.view.layoutIfNeeded()
        })
        // Updates menu status
        menuShowing = !menuShowing
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }

    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // Setup location manager
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            // Do Map Stuff
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructiong them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
