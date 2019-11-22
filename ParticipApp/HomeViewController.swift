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
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var homeButtonView: UIView!
    
    // Menu outlets
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var preferencesButton: UIButton!
    @IBOutlet weak var inboxButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    
    // Categories Menu Outlets
    @IBOutlet weak var catMenuView: UIView!
    @IBOutlet weak var catBtn00: UIButton!
    @IBOutlet weak var catBtn01: UIButton!
    @IBOutlet weak var catBtn02: UIButton!
    @IBOutlet weak var catBtn10: UIButton!
    @IBOutlet weak var catBtn11: UIButton!
    @IBOutlet weak var catBtn12: UIButton!
    @IBOutlet weak var catBtn20: UIButton!
    @IBOutlet weak var catBtn21: UIButton!
    @IBOutlet weak var catBtn22: UIButton!
    @IBOutlet weak var catBtn30: UIButton!
    @IBOutlet weak var catBtn31: UIButton!
    @IBOutlet weak var catBtn32: UIButton!
    @IBOutlet weak var closeCatBtn: UIButton!
    @IBOutlet weak var closeCatMenuView: UIView!
    
    // Array to store all the buttons from Category Menu
    var allButtons: [UIButton] = [UIButton]()
    
    // Variable to know if menu is showing
    var menuIsShowing: Bool = false
    
    // Constant to store corner radius for elements
    let cornerR: CGFloat = 15
    
    // MapKit
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    let regionInMeters: Double = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checks location services
        checkLocationServices()
        
        // Left edge gesture recognizer
        let leftEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftScreenEdgeSwiped(_:)))
        leftEdgePan.edges = .left
        openMenuView.addGestureRecognizer(leftEdgePan)
        
        // Tap gesture recognizer for homeButtonView
        let tapGestureSideMenu = UITapGestureRecognizer(target: self, action: #selector(closeMenu(_:)))
        homeButtonView.addGestureRecognizer(tapGestureSideMenu)
        
        // Right edge pan gesture recognizer for side menu
        let rightEdgePanSideMenu = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(closeMenu(_:)))
        rightEdgePanSideMenu.edges = .right
        homeView.addGestureRecognizer(rightEdgePanSideMenu)
        
        // Tap gesture recognizer for categoryMenu
        let tapGestureCatMenu = UITapGestureRecognizer(target: self, action: #selector(didCloseCatMenu(_:)))
        closeCatMenuView.addGestureRecognizer(tapGestureCatMenu)
        
    // MARK: - HOME ELEMENTS
        
        //Shadow
        homeView.layer.shadowOpacity = 1
        reportButton.layer.shadowOpacity = 1
        
        // Radius
        homeView.layer.shadowRadius = 5
        homeView.layer.cornerRadius = cornerR
        reportButton.layer.cornerRadius = 0.5 * reportButton.bounds.width
        homeButtonView.layer.cornerRadius = cornerR
        
    // MARK: - MENU ELEMENTS
        
        // Radius - menu elements
        mapView.layer.cornerRadius = cornerR
        preferencesButton.layer.cornerRadius = 0.5 * preferencesButton.bounds.size.width
        inboxButton.layer.cornerRadius = 0.5 * inboxButton.bounds.size.width
        
    // MARK: - CATEGORY MENU ELEMENTS
        
        // Adds every category button to array allButtons and makes it a circle
        for view in catMenuView.subviews as [UIView] {
            if let btn = view as? UIButton {
                if btn.tag == 1 {
                    allButtons.append(btn)
                    btn.layer.cornerRadius = 0.5 * btn.bounds.width
                } else {
                    allButtons.append(btn)
                }
            }
        }
        
        
    }
    
    // Opens report category menu
    @IBAction func createReport(_ sender: Any) {
        showCategoryMenu()
    }
    
    
    
    @IBAction func didCloseCatMenu(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false;
        let animDuration: Double = 0.3
        
        // Animates catMenuView and its buttons
        DispatchQueue.main.async {
            for button in self.allButtons {
                UIView.animate(withDuration: animDuration) {
                    button.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    button.alpha = 0
                }
            }
            UIView.animate(withDuration: animDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.catMenuView.alpha = 0
            })
        }
    }
    
    // Left edge pan gesture called
    @objc func leftScreenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            openMenu(self)
        }
    }
    
    // Opens side menu
    @IBAction func openMenu(_ sender: Any) {
        if !menuIsShowing {
            self.navigationController?.navigationBar.isHidden = true;
            menuButton.isEnabled = false
            menuButton.tintColor = UIColor.clear
            openMenuView.alpha = 0
            homeButtonView.alpha = 0.5
            menuLeadingConstraint.constant = 0

            // Menu slide animation
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
            // Updates var menuIsShowing
            menuIsShowing = !menuIsShowing
        }
    }
    
    // Closes side menu
    @objc func closeMenu(_ sender: Any) {
        if menuIsShowing {
            self.navigationController?.navigationBar.isHidden = false;
            homeButtonView.alpha = 0
            menuButton.isEnabled = true
            menuButton.tintColor = UIColor.systemBlue
            openMenuView.alpha  = 1
            menuLeadingConstraint.constant = -375
            
            // Menu slide animation
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
            // Updates var menuIsShowing
            menuIsShowing = !menuIsShowing
        }
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
    
    // Shows report categories
    func showCategoryMenu() {
        
        self.navigationController?.navigationBar.isHidden = true;
        let animDuration: Double = 0.3
        
        // Animates catMenuView and its buttons
        DispatchQueue.main.async {
            UIView.animate(withDuration: animDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.catMenuView.alpha = 0.9
            })
        
            for button in self.allButtons {
                button.transform = button.transform.scaledBy(x: 0.01, y: 0.01)
                UIView.animate(withDuration: animDuration) {
                    button.alpha = 1
                    button.transform = .identity
                }
            }
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
