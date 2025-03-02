//
//  MainViewController.swift
//  LocationPermissionExample
//
//  Created by Adiputra Setiawan on 01/03/25.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    @IBAction func checkoutButtonDidPressed(_ sender: Any) {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
            
        } else if authorizationStatus == .notDetermined {
            
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
            
        } else if authorizationStatus == .denied {
            
            // show alert to enable permission from Settings
            showOpenLocationPermissionSettingsDialog()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showConfirmationDialog(coordinate: LatLng) {
        showAlert(title: "Location",
                  message: "Your location: \(coordinate.latitude), \(coordinate.longitude)",
                  viewController: self)
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
        case .authorizedWhenInUse, .authorizedAlways:
            print("When user select option Allow While Using App or Allow Once")
            print("Start counting")
            locationManager?.startUpdatingLocation()
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        locationManager = nil
        
        if let location = locations.first {
            print("Found user's location: \(location)")
            let coordinate = LatLng(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            showConfirmationDialog(coordinate: coordinate)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error requesting location: \(error.localizedDescription)")
    }
}
