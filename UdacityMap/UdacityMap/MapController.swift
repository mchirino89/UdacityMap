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
        NotificationCenter.default.addObserver(forName: updateStudentNotification, object: nil, queue: nil, using: studentUpdate)
        updateStudents()
    }
    
    func updateStudents() {
        NotificationCenter.default.post(name: updateStudentNotification, object: nil, userInfo: ["isWaitingOn": true])
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            self.mapView.removeAnnotations(self.mapView.annotations)
            Networking.sharedInstance().taskForGETMethod(host: false, path: Constants.Path.Students, parameters: ["limit": 100 as AnyObject, "order": "-updatedAt" as AnyObject], jsonBody: "") { (results, error) in
                if let error = error {
                    print(error)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: updateStudentNotification, object: nil, userInfo: ["isWaitingOn": false])
                        self.present(UdacityMap.getPopupAlert(message: Constants.ErrorMessages.studentLocation), animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        guard let jsonResultArray = results![Constants.JSONResponseKeys.results] as! [[String : AnyObject]]? else { return }
                        let _ = jsonResultArray.map{ StudentDataSource.sharedInstance.studentData.append(Student(dictionary: $0)) }
                        for item in StudentDataSource.sharedInstance.studentData {
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                            annotation.title = "\(item.fullName)"
                            annotation.subtitle = item.mediaURL
                             self.mapView.addAnnotation(annotation)
                        }
                        NotificationCenter.default.post(name: updateStudentNotification, object: nil, userInfo: ["isWaitingOn": false])
                    }
                }
            }
        }
    }
    
    func studentUpdate(notification: Notification) -> Void {
        if let userInfo = notification.userInfo, let isWaitingOn = userInfo["isWaitingOn"] as? Bool {
            isWaitingOn ? setWaitingView(isOn: true, waitingVisualEffect: waitingVisualEffect, view: view) : removeWaitingView(waitingVisualEffect: waitingVisualEffect, view: view)
        } else {
            updateStudents()
        }
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        logOutUser(navigationController: navigationController)
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        NotificationCenter.default.post(name: updateStudentNotification, object: nil, userInfo: nil)
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
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            launchSafari(studentsURL: view.annotation!.subtitle!, studentsFullName: view.annotation!.title!!, navigationController: navigationController)
        }
    }
}
