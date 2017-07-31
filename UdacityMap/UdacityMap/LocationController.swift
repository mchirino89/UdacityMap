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
    @IBOutlet weak var sharingView: UIView!
    @IBOutlet weak var sharingTextField: UITextField!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typedAddressTextField.enablesReturnKeyAutomatically = true
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        middleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showKeyboardAction)))
        questionView.addGestureRecognizer(dismissKeyboardTap)
        addressMap.addGestureRecognizer(dismissKeyboardTap)
        topVisualEffectView.addGestureRecognizer(dismissKeyboardTap)
    }
    
    func showKeyboardAction() {
        questionView.isHidden ? sharingTextField.becomeFirstResponder() : typedAddressTextField.becomeFirstResponder()
    }
    
    func dismissKeyboardAction() {
        view.endEditing(true)
    }
    
    func locateAddressInMap() {
        dismissKeyboardAction()
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
    
    func addSharingLink() {
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
        sharingTextField.isEnabled = !textField.text!.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField == typedAddressTextField ? locateAddressInMap() : addSharingLink()
        return !textField.text!.isEmpty
    }
    
}
