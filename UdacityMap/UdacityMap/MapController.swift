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
    @IBOutlet weak var waitingVisualEffect: UIVisualEffectView!
    @IBOutlet weak var viewNavigationItem: UINavigationItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewNavigationItem.titleView = getCustomTitle()
//        performSegue(withIdentifier: "addLocationFromMapSegue", sender: nil)
        setWaitingView(isOn: true, waitingVisualEffect: self.waitingVisualEffect, view: self.view)
        DispatchQueue.global(qos: .userInteractive).async {
            Networking.sharedInstance().taskForGETMethod(URLExtension: "", host: false, path: Constants.Path.Students, parameters: ["limit": 100 as AnyObject], jsonBody: "") { (results, error) in
                if let error = error {
                    print(error)
                    DispatchQueue.main.async{
                        setWaitingView(isOn: false, waitingVisualEffect: self.waitingVisualEffect, view: self.view)
                        self.present(UdacityMap.getErrorAlert(errorMessage: Constants.ErrorMessages.studentLocation), animated: true)
                    }
                } else {
                    DispatchQueue.main.async{
                        print(results!)
                        UIView.animate(withDuration: 0.3, animations: {
                            self.waitingVisualEffect.alpha = 0
                        }, completion: { _ in
                            self.view.sendSubview(toBack: self.waitingVisualEffect)
                        })
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
