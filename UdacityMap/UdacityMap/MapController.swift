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
//        performSegue(withIdentifier: "addLocationFromMapSegue", sender: nil)
        
        DispatchQueue.global(qos: .userInteractive).async {
            let _ = Networking.sharedInstance().taskForGETMethod(URLExtension: "limit=100", host: false, path: Constants.Path.Students, parameters: ["X-Parse-Application-Id": Constants.APIConfiguration.AppId as AnyObject, "X-Parse-REST-API-Key": Constants.APIConfiguration.ApiKey as AnyObject], jsonBody: "") { (results, error) in
                if let error = error {
                    print(error)
                    DispatchQueue.main.async{
                        
                    }
                } else {
                    DispatchQueue.main.async{
                        print(results!)
                    }
                }
            }
        }
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
