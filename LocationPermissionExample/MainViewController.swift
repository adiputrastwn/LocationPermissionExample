//
//  MainViewController.swift
//  LocationPermissionExample
//
//  Created by Adiputra Setiawan on 01/03/25.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func checkoutButtonDidPressed(_ sender: Any) {
        showAlert(title: "Alert", message: "Button checkout pressed", viewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
