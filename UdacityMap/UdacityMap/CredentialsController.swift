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
    @IBOutlet weak var loginButton: ButtonStyleController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginAction() {
        print("Loging!")
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        UIApplication.shared.open(URL(string: Networking.URL.SignUp)!, options: [:], completionHandler: nil)
    }
    
    func enableLogin() {
        loginButton.isEnabled = !passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension CredentialsController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            print("GO!")
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enableLogin()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableLogin()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Only when both textfileds are populated will login button be enabled
        enableLogin()
        return true
    }
}
