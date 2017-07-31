//
//  MapController.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 29/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewNavigationItem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewNavigationItem.titleView = getCustomTitle()

        performSegue(withIdentifier: "addLocationFromMapSegue", sender: nil)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        logOutUser(navigationController: navigationController)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
    }
}

extension MapController: MKMapViewDelegate {
//    map
}
