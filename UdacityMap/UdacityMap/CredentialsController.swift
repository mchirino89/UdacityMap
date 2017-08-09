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
    @IBOutlet weak var waitingVisualEffect: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        passwordTextField.enablesReturnKeyAutomatically = true
        emailTextField.enablesReturnKeyAutomatically = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction)))
        // MARK: Testing purposes
        emailTextField.text = "m.chirino89@gmail.com"
        passwordTextField.text = "QnkYyXRu4Z0is2mFFuffgpdQLPR0ssN8jI"
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
        loginButton.isEnabled = !passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func performLogin() {
        view.endEditing(true)
        setWaitingView(isOn: true, waitingVisualEffect: self.waitingVisualEffect, view: self.view)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            // Quick question: Is this the proper form to prevent a retain cycle in here?
            [unowned self] in
            let jsonPayload = "{\"udacity\": {\"username\": \"\(self.emailTextField.text!)\", \"password\": \"\(self.passwordTextField.text!)\"}}"
            Networking.sharedInstance().taskForPOSTMethod(host: true, path: Constants.Path.SignIn, parameters: [:], jsonBody: jsonPayload) {
                (results, error) in
                if let error = error {
                    print(error)
                    DispatchQueue.main.async {
                        setWaitingView(isOn: false, waitingVisualEffect: self.waitingVisualEffect, view: self.view)
                        if error.code == 403 {
                            self.present(UdacityMap.getErrorAlert(errorMessage: Constants.ErrorMessages.credentials), animated: true)
                        } else {
                            self.present(UdacityMap.getErrorAlert(errorMessage: Constants.ErrorMessages.internetConnection), animated: true)
                        }
                    }
                } else {
                    guard let JSONresponse = results else { return }
                    print(JSONresponse)
                    // What's the difference between casting as! 👇🏽
                    Networking.sharedInstance().sessionID = JSONresponse[Constants.JSONResponseKeys.Session]![Constants.JSONResponseKeys.UserID] as? String
                    // And casting as? 👇🏽?
                    Networking.sharedInstance().userID = Int(JSONresponse[Constants.JSONResponseKeys.Account]![Constants.JSONResponseKeys.Key] as! String)
                    UserDefaults.standard.set(Networking.sharedInstance().userID ?? 0, forKey: Constants.Session.AccountKey)
                    UserDefaults.standard.set(Networking.sharedInstance().sessionID ?? "user-token", forKey: Constants.Session.Id)
                    
                    Networking.sharedInstance().taskForGETMethod(host: false, path: Constants.Path.Students, parameters: ["where": "{\"uniqueKey\":\"\(Networking.sharedInstance().userID ?? 0)\"}" as AnyObject], jsonBody: "") {
                        (results, error) in
                        guard let jsonResultArray = results![Constants.JSONResponseKeys.results] as! [[String : AnyObject]]? else { print(error.debugDescription); return }
                        Networking.sharedInstance().name = jsonResultArray[0][Constants.JSONResponseKeys.name] as! String
                        Networking.sharedInstance().lastName = jsonResultArray[0][Constants.JSONResponseKeys.lastName] as! String
                    }
                    
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: Constants.Storyboard.loginSegue, sender: nil)
                        self.passwordTextField.text = ""
                        self.emailTextField.text = ""
                        setWaitingView(isOn: false, waitingVisualEffect: self.waitingVisualEffect, view: self.view)
                    }
                }
            }
        }
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
