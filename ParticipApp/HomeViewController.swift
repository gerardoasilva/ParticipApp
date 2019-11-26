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
    @IBOutlet weak var levelButton: UIButton!
    @IBOutlet weak var menuTransparentView: UIView!
    
    // Rewards Menu Outlets
    @IBOutlet weak var rewardsHeader: UIView!
    @IBOutlet weak var rewardsHandlerLine: UIView!
    @IBOutlet weak var rewardsMenu: UIView!
    @IBOutlet weak var headerBottom: NSLayoutConstraint!
    @IBOutlet weak var rewardsTransparentView: UIView!
    
    
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
    @IBOutlet weak var closeCatBtn: UIButton!
    @IBOutlet weak var closeCatMenuView: UIView!
    
    // Subcategories Menu Outlet
    @IBOutlet weak var subCatMenuView: UIView!
    @IBOutlet weak var subBtn00: UIButton!
    @IBOutlet weak var subBtn01: UIButton!
    @IBOutlet weak var subBtn02: UIButton!
    @IBOutlet weak var subBtn10: UIButton!
    @IBOutlet weak var subBtn11: UIButton!
    @IBOutlet weak var subBtn12: UIButton!
    @IBOutlet weak var subBtn20: UIButton!
    @IBOutlet weak var subBtn21: UIButton!
    @IBOutlet weak var subBtn22: UIButton!
    @IBOutlet weak var closeSubBtn: UIButton!
    @IBOutlet weak var closeSubCatMenuView: UIView!
    
    
    // Array to store all the buttons from Category Menu
    var allCatButtons: [UIButton] = [UIButton]()
    
    // Array to store all the buttons from SubCategory Menu
    var allSubButtons: [UIButton] = [UIButton]()
    
    // Variable to know if menu is showing
    var sideMenuIsShowing: Bool = false
    
    // Variable to keep track of categories menu
    var catMenuIsShowing: Bool = false
    
    // Variable to keep track of subcategories menu
    var subCatMenuIsShowing: Bool = false
    
    // Variable to keep track of rewards Menu
    var rewardsMenuIsShowing: Bool = false
    
    // Constant to store corner radius for elements
    let cornerR: CGFloat = 15
    
    // MAPKIT
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    let regionInMeters: Double = 500
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checks location services
        checkLocationServices()
        
        // Adds listener for side menu closed definitely
        NotificationCenter.default.addObserver(self, selector: #selector(onDidCloseDefinitely(_:)), name: .didCloseDefinitely, object: nil)
        
        // Custom back nav bar button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Left edge gesture recognizer
        let leftEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftScreenEdgeSwiped(_:)))
        leftEdgePan.edges = .left
        openMenuView.addGestureRecognizer(leftEdgePan)
        
//        // Tap gesture recognizer for homeButtonView
//        let tapGestureSideMenu = UITapGestureRecognizer(target: self, action: #selector(closeMenu(_:)))
//        homeButtonView.addGestureRecognizer(tapGestureSideMenu)
        
//        // Right edge pan gesture recognizer for side menu
//        let rightEdgePanSideMenu = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(closeMenu(_:)))
//        rightEdgePanSideMenu.edges = .right
//        homeView.addGestureRecognizer(rightEdgePanSideMenu)
        
        // Tap gesture recognizer for menuTransparentView
        let tapGestureMenuTransparentView = UITapGestureRecognizer(target: self, action: #selector(closeMenu(_:)))
        menuTransparentView.addGestureRecognizer(tapGestureMenuTransparentView)
        
        // Right edge pan gesture recognizer for menuTransparentView
        let rightEdgePanMenuTransparentView = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(closeMenu(_:)))
        rightEdgePanMenuTransparentView.edges = .right
        menuTransparentView.addGestureRecognizer(rightEdgePanMenuTransparentView)
        
        // Tap gesture recognizer for categoryMenu
        let tapGestureCatMenu = UITapGestureRecognizer(target: self, action: #selector(didCloseCatMenu(_:)))
        closeCatMenuView.addGestureRecognizer(tapGestureCatMenu)
        
        // Tap gesture recognizer for subcatMenu
        let tapGestureSubCatMenu = UITapGestureRecognizer(target: self, action: #selector(didCloseSubCatMenu(_:)))
        closeSubCatMenuView.addGestureRecognizer(tapGestureSubCatMenu)
        
        // Tap gesture recognzer for rewards menu header
        let tapGestureRewardsHeader = UITapGestureRecognizer(target: self, action: #selector(didTouchHeader(_:)))
        rewardsHeader.addGestureRecognizer(tapGestureRewardsHeader)
    
        // Tap gesture recognizer for transparent view
        let tapGestureTransparentView = UITapGestureRecognizer(target: self, action: #selector(didTouchHeader(_:)))
        rewardsTransparentView.addGestureRecognizer(tapGestureTransparentView)
        
    // MARK: - HOME ELEMENTS
        
        //Shadow
        homeView.layer.shadowOpacity = 1
        homeView.layer.shadowRadius = 0.25
        reportButton.layer.shadowOpacity = 1
        
        // Radius
        homeView.layer.shadowRadius = 5
        homeView.layer.cornerRadius = cornerR
        reportButton.layer.cornerRadius = 0.5 * reportButton.bounds.width
//        homeButtonView.layer.cornerRadius = cornerR
        
    // MARK: - REWARDS MENU ELEMENTS
        
        // Radius
        rewardsHeader.layer.cornerRadius = cornerR
        rewardsHeader.layer.shadowOpacity = 0
        rewardsHeader.layer.shadowRadius = 3
        rewardsMenu.alpha = 0
        
        
        
    // MARK: - SIDE MENU ELEMENTS
        
        // Radius - menu elements
        mapView.layer.cornerRadius = cornerR
        levelButton.layer.cornerRadius = 0.5 * levelButton.bounds.width
        menuTransparentView.layer.cornerRadius = cornerR
        
    // MARK: - CATEGORY MENU ELEMENTS
        
        // Adds every category button to array allCatButtons and makes it a circle
        for view in catMenuView.subviews as [UIView] {
            if let btn = view as? UIButton {
                if btn.tag == 1 {
                    allCatButtons.append(btn)
                    btn.layer.cornerRadius = 0.5 * btn.bounds.width
                } else {
                    allCatButtons.append(btn)
                }
            }
        }
        
        // Adds every subcat button to array allSubButtons and makes it a circle
        for view in subCatMenuView.subviews as [UIView] {
            if let btn = view as? UIButton {
                if btn.tag == 1 {
                    allSubButtons.append(btn)
                    btn.layer.cornerRadius = 0.5 * btn.bounds.width
                } else {
                    allSubButtons.append(btn)
                }
            }
        }
        
        
    }
    
    // When rewards menu header is touched
    @objc func didTouchHeader(_ sender: Any) {
        if !rewardsMenuIsShowing {
            self.navigationController?.navigationBar.isHidden = true
            homeView.isUserInteractionEnabled = false
            rewardsMenu.alpha = 1
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.rewardsTransparentView.alpha = 0.5
                self.headerBottom.constant = 726
                self.rewardsHeader.layer.shadowOpacity = 0.5
                self.view.layoutIfNeeded()
            })
        } else {
            self.navigationController?.navigationBar.isHidden = false
            homeView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.rewardsTransparentView.alpha = 0
                self.headerBottom.constant = 0
                self.rewardsHeader.layer.shadowOpacity = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.rewardsMenu.alpha = 0
            })

        }
        self.rewardsMenuIsShowing = !self.rewardsMenuIsShowing
        
    }
    
    // Opens report category menu
    @IBAction func createReport(_ sender: Any) {
        showCategoryMenu()
    }
    
    @IBAction func selectedCategory(_ sender: Any) {
        showSubCatMenu()
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
            
            for button in self.allCatButtons {
                button.transform = button.transform.scaledBy(x: 0.01, y: 0.01)
                UIView.animate(withDuration: animDuration) {
                    button.alpha = 1
                    button.transform = .identity
                }
            }
        }
    }
    
    // Shows report subcategories
    func showSubCatMenu() {
        
        self.navigationController?.navigationBar.isHidden = true;
        let animDuration: Double = 0.3
        
        // Animates catMenuView and its buttons
        DispatchQueue.main.async {
            UIView.animate(withDuration: animDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.catMenuView.alpha = 0
                self.subCatMenuView.alpha = 0.9
            })
            
            for button in self.allSubButtons {
                button.transform = button.transform.scaledBy(x: 0.01, y: 0.01)
                UIView.animate(withDuration: animDuration) {
                    button.alpha = 1
                    button.transform = .identity
                }
            }
        }
    }
    
    // Closes categoryMenu
    @IBAction func didCloseCatMenu(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        let animDuration: Double = 0.3
        
        // Animates catMenuView and its buttons
        DispatchQueue.main.async {
            for button in self.allCatButtons {
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
    
    @IBAction func didCloseSubCatMenu(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
        let animDuration: Double = 0.3
        
        // Animates catMenuView and its buttons
        DispatchQueue.main.async {
            for button in self.allSubButtons {
                UIView.animate(withDuration: animDuration) {
                    button.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                    button.alpha = 0
                }
            }
            UIView.animate(withDuration: animDuration, delay: 0, options: [.curveEaseInOut], animations: {
                self.subCatMenuView.alpha = 0
            })
        }
    }
    
    // Left edge pan gesture called
    @objc func leftScreenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            openMenu(self)
        }
    }
    
    // Opens left side menu
    @IBAction func openMenu(_ sender: Any) {
        if !sideMenuIsShowing {
            navigationController?.navigationBar.isHidden = true;
            rewardsMenu.isUserInteractionEnabled = false
            //homeButtonView.alpha = 0.5
            //openMenuView.alpha = 0
            //menuButton.isEnabled = false
            //menuButton.tintColor = UIColor.clear
            

            // Menu slide animation
            UIView.animate(withDuration: 0.3, animations: {
                self.menuTransparentView.alpha = 0.5
                self.menuLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
            
            // Updates var menuIsShowing
            sideMenuIsShowing = !sideMenuIsShowing
        }
    }
    
    // Closes left side menu
    @objc func closeMenu(_ sender: Any) {
        if sideMenuIsShowing {
            navigationController?.navigationBar.isHidden = false;
            rewardsMenu.isUserInteractionEnabled = true
            //homeButtonView.alpha = 0
            //openMenuView.alpha  = 1
            //menuButton.isEnabled = true
            //menuButton.tintColor = UIColor.systemBlue
            
            
            // Menu slide animation
            UIView.animate(withDuration: 0.3, animations: {
                self.menuTransparentView.alpha = 0
                self.menuLeadingConstraint.constant = -375
                self.view.layoutIfNeeded()
            })
            
            // Updates var menuIsShowing
            sideMenuIsShowing = !sideMenuIsShowing
        }
    }
    
    // Closes side menu definitely
    @objc func closeMenuDefinitely(_ sender: Any) {
        if sideMenuIsShowing {
            navigationController?.navigationBar.isHidden = false;
            menuTransparentView.alpha = 0
            menuLeadingConstraint.constant = -375
            openMenuView.alpha  = 1
            
            // Updates var menuIsShowing
            sideMenuIsShowing = !sideMenuIsShowing
        }
    }
    
// MARK: - LISTENERS
    
    // Listener for definitive closeMenu
    @objc func onDidCloseDefinitely(_ notification: Notification) {
        closeMenuDefinitely(self)
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

extension Notification.Name {
    static let didCloseDefinitely = Notification.Name("didCloseDefinitely")
}
