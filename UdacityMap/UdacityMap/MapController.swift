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
            Networking.sharedInstance().taskForGETMethod(URLExtension: "", host: false, path: Constants.Path.Students, parameters: ["limit": 100 as AnyObject], jsonBody: "") {
                (results, error) in
                if let error = error {
                    print(error)
                    DispatchQueue.main.async{
                        setWaitingView(isOn: false, waitingVisualEffect: self.waitingVisualEffect, view: self.view)
                        self.present(UdacityMap.getErrorAlert(errorMessage: Constants.ErrorMessages.studentLocation), animated: true)
                    }
                } else {
                    DispatchQueue.main.async{
                        guard let jsonResultArray = results![Constants.JSONResponseKeys.results] as! [[String : AnyObject]]? else { return }
                        var studentsList:[Student] = []
                        let _ = jsonResultArray.map{ studentsList.append(Student(dictionary: $0)) }
                        var annotations = [MKPointAnnotation]()
                        for item in studentsList {
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                            annotation.title = "\(item.firstName) \(item.lastName)"
                            annotation.subtitle = item.mediaURL
                            annotations.append(annotation)
                            // What's the difference between adding annotantios directly into the map here 👇🏽
//                            self.mapView.addAnnotation(annotation)
                        }
                        // And adding them like this? 👇🏽
                        self.mapView.addAnnotations(annotations)
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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.UIElements.mapPin) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.UIElements.mapPin)
            pinView!.animatesDrop = true
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: { (success) in
                    print("\(success) for URL \(toOpen)")
                })
            }
        }
    }
}
