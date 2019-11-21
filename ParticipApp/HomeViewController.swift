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
    
    // Home outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var openMenuView: UIView!
    @IBOutlet weak var recompensas: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    // Menu outlets
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var preferencesButton: UIButton!
    @IBOutlet weak var inboxButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    // Variable to know if menu is showing
    var menuIsShowing: Bool = false
    
    // Constant to store corner radius for elements
    let cornerR: CGFloat = 15
    
    // MapKit
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    let regionInMeters: Double = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Left edge gesture recognizer
        let leftEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftScreenEdgeSwiped))
        leftEdgePan.edges = .left
        
        // Right edge gesture recognizer
        let rightEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(rightScreenEdgeSwiped))
        rightEdgePan.edges = .right
        
        // Add gesture recognizer to view
        openMenuView.addGestureRecognizer(leftEdgePan)
        
        // Checks location services
        checkLocationServices()
        
    // MARK: - HOME ELEMENTS
        
        //Shadow
        homeView.layer.shadowOpacity = 1
        reportButton.layer.shadowOpacity = 1
        
        // Radius
        homeView.layer.shadowRadius = 5
        homeView.layer.cornerRadius = cornerR
        reportButton.layer.cornerRadius = 0.5 * reportButton.bounds.width
        
    // MARK: - MENU ELEMENTS
        
        // Radius - menu elements
        recompensas.layer.cornerRadius = cornerR
        mapView.layer.cornerRadius = cornerR
        preferencesButton.layer.cornerRadius = 0.5 * preferencesButton.bounds.size.width
        inboxButton.layer.cornerRadius = 0.5 * inboxButton.bounds.size.width
        homeButton.layer.cornerRadius = cornerR
        
    }
    
    // Left edge pan gesture called
    @objc func leftScreenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            if !menuIsShowing {
                openMenu(self)
            }
        }
    }
    
    // Opens side menu
    @IBAction func openMenu(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = true;
        menuLeadingConstraint.constant = 0
        menuButton.isEnabled = false
        menuButton.tintColor = UIColor.clear
        homeButton.isEnabled = true
        homeButton.alpha = 0.5
        openMenuView.alpha = 0
            
        // Menu slide animation
        UIView.animate(withDuration: 0.15, animations: {
            self.view.layoutIfNeeded()
        })
        
        // Updates var menuIsShowing
        menuIsShowing = !menuIsShowing
    }
    
    // Closes side menu
    @IBAction func closeMenu(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false;
        menuLeadingConstraint.constant = -375
        homeButton.isEnabled = false
        homeButton.alpha = 0
        menuButton.isEnabled = true
        menuButton.tintColor = UIColor.systemBlue
        openMenuView.alpha  = 1
        
        // Menu slide animation
        UIView.animate(withDuration: 0.15, animations: {
            self.view.layoutIfNeeded()
        })
        
        // Updates var menuIsShowing
        menuIsShowing = !menuIsShowing
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
