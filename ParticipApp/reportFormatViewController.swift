//
//  reportFormatViewController.swift
//  ParticipApp
//
//  Created by Gerardo Silva Razo on 11/25/19.
//  Copyright © 2019 Gerardo Silva Razo. All rights reserved.
//

import UIKit
import MapKit

class reportFormatViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet var reportFormatView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var reportButton: UIButton!
    // MAPKIT
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    let regionInMeters: Double = 300
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Checks location services
        checkLocationServices()
 
        descriptionField.layer.cornerRadius = 15
        reportButton.layer.cornerRadius = 15
        
        // Adds left edge pan gesture recognizer to the view controller
        let leftEdgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didGoBack(_:)))
        leftEdgePan.edges = .left
        reportFormatView.addGestureRecognizer(leftEdgePan)
        
    }

    @IBAction func didReport(_ sender: Any) {
        // Notifies the homeViewController to close catMenus definitely
        NotificationCenter.default.post(name: .didCloseReport, object: nil)
        
        if let navController = self.navigationController {
                  navController.popViewController(animated: true)
              }
    }
    
    @objc func didGoBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension reportFormatViewController: CLLocationManagerDelegate {
    
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
