//
//  LocationController.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 30/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit
import MapKit

class LocationController: UIViewController {
    
    @IBOutlet weak var dismissViewButton: UIButton!
    @IBOutlet weak var topVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var addressMap: MKMapView!
    @IBOutlet weak var bottomVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var findLocationButton: ButtonStyle!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var typedAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typedAddressTextField.enablesReturnKeyAutomatically = true
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        middleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showKeyboardAction)))
        questionView.addGestureRecognizer(dismissKeyboardTap)
        topVisualEffectView.addGestureRecognizer(dismissKeyboardTap)
    }
    
    func showKeyboardAction() {
        typedAddressTextField.becomeFirstResponder()
    }
    
    func dismissKeyboardAction() {
        typedAddressTextField.resignFirstResponder()
    }
    
    func locateAddressInMap() {
        dismissKeyboardAction()
        
    }
    
    @IBAction func findLocationAction() {
        locateAddressInMap()
    }
    
    @IBAction func dismissViewAction() {
        dismissKeyboardAction()
        dismiss(animated: true, completion: nil)
    }

}

extension LocationController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        findLocationButton.isEnabled = !textField.text!.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locateAddressInMap()
        return !textField.text!.isEmpty
    }
    
}
