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
        } else if authorizationStatus == .denied {
            // show alert to enable permission from Settings
            showOpenLocationPermissionSettingsDialog()
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
    
    func showOpenLocationPermissionSettingsDialog() {
        let alertController = UIAlertController(
            title: "Location Permission Required",
            message: "Please enable location permissions in settings.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //Redirect to Settings app
            UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
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
