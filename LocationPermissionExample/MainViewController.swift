//
//  MainViewController.swift
//  LocationPermissionExample
//
//  Created by Adiputra Setiawan on 01/03/25.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    // 1
    var locationManager: CLLocationManager?
    
    @IBAction func checkoutButtonDidPressed(_ sender: Any) {
        // 3
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .authorizedWhenInUse {
            showConfirmationDialog()
        } else if authorizationStatus == .notDetermined {
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2
        locationManager = CLLocationManager()
        
    }
    
    func showConfirmationDialog() {
        showAlert(title: "Checkout", message: "Continue for checkout", viewController: self)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("When user did not yet determined")
        case .restricted:
            print("Restricted by parental control")
        case .denied:
            print("When user select option Dont't Allow")
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow Once")
            showConfirmationDialog()
        default:
            print("default")
        }
    }
}
