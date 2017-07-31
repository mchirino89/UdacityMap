//
//  ViewController.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 22/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit

class CredentialsController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: ButtonStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        passwordTextField.enablesReturnKeyAutomatically = true
        emailTextField.enablesReturnKeyAutomatically = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction)))
    }
    
    @IBAction func loginAction() {
        performLogin()
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: Constants.URL.SignUp)!, options: [:], completionHandler: nil)
    }
    
    // Only when both textfileds are populated will login button be enabled
    func enableLogin(_ textField: UITextField) {
        textField.returnKeyType = textField == emailTextField && passwordTextField.text!.isEmpty ? .next : .go
        loginButton.isEnabled = true
//        loginButton.isEnabled = !passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func performLogin() {
        view.endEditing(true)
        UserDefaults.standard.set(true, forKey: Constants.APPConfiguration.LoggedIn)
        performSegue(withIdentifier: Constants.Storyboard.loginSegue, sender: nil)
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    //# Keyboard events and handling
    
    func keyboardWillShow(_ notification:Notification) {
        if view.frame.origin.y >= 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if view.frame.origin.y < 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func dismissKeyboardAction() {
        view.endEditing(true)
    }

}

extension CredentialsController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField && passwordTextField.text!.isEmpty {
            passwordTextField.becomeFirstResponder()
        } else if textField == emailTextField && !passwordTextField.text!.isEmpty {
            performLogin()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enableLogin(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableLogin(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enableLogin(textField)
        return true
    }

}
