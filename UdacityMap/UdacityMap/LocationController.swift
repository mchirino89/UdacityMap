//
//  LocationController.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 30/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationController: UIViewController {
    
    @IBOutlet weak var dismissViewButton: UIButton!
    @IBOutlet weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var addressMap: MKMapView!
    @IBOutlet weak var bottomVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var findLocationButton: ButtonStyle!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var typedAddressTextField: UITextField!
    @IBOutlet weak var sharingView: UIView!
    @IBOutlet weak var sharingTextField: UITextField!
    @IBOutlet weak var waitingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var submitButton: ButtonStyle!
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = 25
        typedAddressTextField.enablesReturnKeyAutomatically = true
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        middleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showKeyboardAction)))
        questionView.addGestureRecognizer(dismissKeyboardTap)
        topVisualEffectView.addGestureRecognizer(dismissKeyboardTap)
        // Testing
        typedAddressTextField.text = "Barrio Obrero Tachira"
        sharingTextField.text = "https://www.linkedin.com/in/mauriciochirino/"
        locateAddressInMap(typedAddressTextField.text!)
        submitButton.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        typedAddressTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        geoCoder.cancelGeocode()
    }
    
    func showKeyboardAction() {
        _ = questionView.isHidden ? sharingTextField.becomeFirstResponder() : typedAddressTextField.becomeFirstResponder()
    }
    
    func dismissKeyboardAction() {
        view.endEditing(true)
    }
    
    func locateAddressInMap(_ address: String) {
        if !address.isEmpty {
            dismissKeyboardAction()
            setWaitingState(loading: true)
            DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                // Background thread
                self.geoCoder.geocodeAddressString(address) {  (placemarks, error) in
                    DispatchQueue.main.async {
                        // Coming back to main UI thread
                        self.setWaitingState(loading: false)
                        if let placemarks = placemarks, let location = placemarks.first?.location {
                            self.addPinInMap(coordinates: location.coordinate)
                        } else  {
                            self.noLocationFound()
                        }
                    }
                }
            }
        }
    }
    
    func setWaitingState(loading: Bool) {
        loading ? waitingActivityIndicator.startAnimating() : waitingActivityIndicator.stopAnimating()
        typedAddressTextField.isEnabled = !loading
        findLocationButton.isEnabled = !loading
        sharingTextField.isEnabled = !loading
    }
    
    func enableButtons() {
        findLocationButton.isEnabled = !typedAddressTextField.text!.isEmpty
        submitButton.isEnabled = !sharingTextField.text!.isEmpty
    }
    
    private func sharingViewTransition() {
        sharingView.isHidden = false
        bottomVisualEffectView.isHidden = true
        bottomView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.questionView.alpha = 0
            self.topVisualEffectView.backgroundColor = UIColor.blue
            self.topVisualEffectView.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
            self.middleView.alpha = 0
            self.sharingView.alpha = 1
            self.addressMap.alpha = 1
            self.dismissViewButton.titleLabel!.textColor = UIColor.white
            self.findLocationButton.backgroundColor = UIColor.white
        }, completion: { _ in
            self.questionView.isHidden = true
            self.middleView.isHidden = true
        })
    }
    
    // If geocode fails, user is given the choice to share his current location instead
    private func noLocationFound() {
        let getLocationPopup = questionPopup(title: Constants.ErrorMessages.noLocationFound, message: Constants.UIMessages.locationPermission, style: .alert, afirmativeAction: {
            [unowned self] _ in
            // If it was previously denied and he wants to change that, he will be taken directly to the app's settings page
            if CLLocationManager.authorizationStatus() == .denied {
                let secondChancePopup = questionPopup(title: Constants.ErrorMessages.popupTitle, message: Constants.ErrorMessages.previouslyDenied, style: .alert, afirmativeAction: { _ in
                    if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:])
                    }
                })
                self.present(secondChancePopup, animated: true)
            // Otherwise, request his permission and retrieve current location
            } else {
                self.setWaitingState(loading: true)
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
            }
        })
        present(getLocationPopup, animated: true)
    }
    
    func submitNewPin() {
        dismissKeyboardAction()
        setWaitingState(loading: true)
        DispatchQueue.global(qos: .userInteractive).async {
            [unowned self] in
            let pinCoordinate = self.addressMap.annotations[0].coordinate
            let jsonPayload = "{\"firstName\": \"\(Networking.sharedInstance().name)\", \"lastname\": \"\(Networking.sharedInstance().lastName)\", \"mapString\": \"\(self.typedAddressTextField.text!)\", \"mediaURL\": \"\(self.sharingTextField.text!)\", \"latitude\": \(pinCoordinate.latitude), \"longitude\": \(pinCoordinate.longitude)}"
            print(jsonPayload)
            
            Networking.sharedInstance().taskForPOSTMethod(host: false, path: Constants.Path.Students, parameters: ["uniqueKey": Networking.sharedInstance().userID! as AnyObject], jsonBody: jsonPayload) {
                (results, error) in
                if let error = error {
                    print(error)
                    DispatchQueue.main.async {
                        self.setWaitingState(loading: false)
                        self.present(getPopupAlert(message: Constants.ErrorMessages.newPinAddition), animated: true)
                    }
                } else {
                    guard let JSONresponse = results else { return }
                    print(JSONresponse)
                    DispatchQueue.main.async {
                        self.setWaitingState(loading: false)
                        NotificationCenter.default.post(name: updateStudentNotification, object: nil, userInfo: nil)
                        self.navigationController?.present(getPopupAlert(message: Constants.UIMessages.postedPinTitle, title: Constants.UIMessages.postedPinMessage, buttonText: Constants.UIMessages.postedPinButton), animated: true)
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func addPinInMap(coordinates: CLLocationCoordinate2D) {
        setWaitingState(loading: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        addressMap.addAnnotation(annotation)
        addressMap.setCenter(coordinates, animated: true)
        sharingViewTransition()
    }
    
    @IBAction func findLocationAction() {
        locateAddressInMap(typedAddressTextField.text!)
    }
    
    @IBAction func dismissViewAction() {
        dismissKeyboardAction()
        dismiss(animated: true, completion: nil)
    }

    @IBAction func submitLinkAction() {
        submitNewPin()
    }
}

extension LocationController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableButtons()
        dismissKeyboardAction()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enableButtons()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField == typedAddressTextField ? locateAddressInMap(textField.text!) : submitNewPin()
        return !textField.text!.isEmpty
    }
    
}

extension LocationController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        dismissKeyboardAction()
    }
}

extension LocationController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        addPinInMap(coordinates: locations.first!.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        setWaitingState(loading: false)
        present(getPopupAlert(message: Constants.ErrorMessages.noGPS), animated: true)
    }
}
