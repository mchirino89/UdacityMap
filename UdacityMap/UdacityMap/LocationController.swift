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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
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
        nameTextField.isEnabled = !loading
        lastNameTextField.isEnabled = !loading
        sharingTextField.isEnabled = !loading
    }
    
    func enableButtons() {
        findLocationButton.isEnabled = !typedAddressTextField.text!.isEmpty
        submitButton.isEnabled = !sharingTextField.text!.isEmpty
    }
    
    func newPinValidation() {
        dismissKeyboardAction()
        if nameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty {
            let missingInfoPopup = questionPopup(title: Constants.UIMessages.missingInfoTitle, message: Constants.UIMessages.missingIngoMessage, style: .alert, afirmativeAction: {
                [unowned self] _ in self.submitNewPin()
            })
            present(missingInfoPopup, animated: true)
        } else {
            submitNewPin()
        }
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
    
    private func submitNewPin() {
        setWaitingState(loading: true)
        DispatchQueue.global(qos: .userInteractive).async {
            [unowned self] in
            let pinCoordinate = self.addressMap.annotations[0].coordinate
            let jsonPayload = "{\"uniqueKey\": \"\(Networking.sharedInstance().userID!)\", \"firstName\": \"\(self.nameTextField.text!)\", \"lastName\": \"\(self.lastNameTextField.text!)\",\"mapString\": \"\(self.typedAddressTextField.text!)\", \"mediaURL\": \"\(self.sharingTextField.text!)\",\"latitude\": \(pinCoordinate.latitude), \"longitude\": \(pinCoordinate.longitude)}"
            print(jsonPayload)
            
            // In here i'm getting 403 error but i'm following the API documentations you guys provided. Please help
            
            // It seems you didn't read my previous comment above 👆🏽. On top of that please have a look at the documentation please, there's no (or at least i don't see where) i can get the user name and last name. This 👉🏽 https://d17h27t6h515a5.cloudfront.net/topher/2016/June/57583f67_post-session/post-session.json is the response i get and it's the same as posted in the documentation here: https://classroom.udacity.com/nanodegrees/nd003/parts/99f2246b-fb9e-41a9-9834-3b7db87f7628/modules/0e6213b2-bc78-490c-a967-f67fa258ed12/lessons/3071699113239847/concepts/f1858f50-76e4-40ee-9309-d597c70d0619 for login endpoint.
            
            Networking.sharedInstance().taskForPOSTMethod(URLExtension: "", host: false, path: Constants.Path.Students, parameters: [:], jsonBody: jsonPayload) {
                (results, error) in
                if let error = error {
                    print(error)
                    DispatchQueue.main.async {
                        self.setWaitingState(loading: false)
                        self.present(getErrorAlert(errorMessage: Constants.ErrorMessages.newPinAddition), animated: true)
                    }
                } else {
                    guard let JSONresponse = results else { return }
                    print(JSONresponse)
                    DispatchQueue.main.async {
                        self.setWaitingState(loading: false)
                        NotificationCenter.default.post(name: updateStudentNotification, object: nil, userInfo: nil)
                        self.dismiss(animated: true, completion: {
                            print("All went good and view dismissed")
                        })
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
        newPinValidation()
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
        textField == typedAddressTextField ? locateAddressInMap(textField.text!) : newPinValidation()
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
        present(getErrorAlert(errorMessage: Constants.ErrorMessages.noGPS), animated: true)
    }
}
