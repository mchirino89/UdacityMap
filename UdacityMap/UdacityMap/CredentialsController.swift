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
    @IBOutlet weak var waitinTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        passwordTextField.enablesReturnKeyAutomatically = true
        emailTextField.enablesReturnKeyAutomatically = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction)))
        let _ = Networking.sharedInstance().taskForPOSTMethod(URLExtension: "", host: true, path: Constants.Path.SignIn, parameters: [:], jsonBody: "{\"udacity\": {\"username\": \"m.chirino89@gmail.com\", \"password\": \"QnkYyXRu4Z0is2mFFuffgpdQLPR0ssN8jI\"}}") {
            (results, error) in
            if let error = error {
                print(error)
            } else {
                guard let JSONresponse = results else { return }
                print(JSONresponse)
                print("Account: ")
                print(JSONresponse[Constants.JSONResponseKeys.Account]![Constants.JSONResponseKeys.Key]!!)
                print("Session:")
                print(JSONresponse[Constants.JSONResponseKeys.Session]![Constants.JSONResponseKeys.UserID]!!)
//                Networking.sharedInstance().userID = results?[Constants.JSONResponseKeys.Account]?[Constants.JSONResponseKeys.Key] as? Int
//                results!.
//                Networking.sharedInstance().sessionID = JSONresponse[Constants.JSONResponseKeys.Session]?[Constants.JSONResponseKeys.UserID] as? String
//                print(Networking.sharedInstance().userID!)
//                print(Networking.sharedInstance().sessionID!)
            }
            print("\n\n\n")
        }
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
        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.waitinTopConstraint.constant = 0
//        })
//        if success
//        UserDefaults.standard.set(true, forKey: Constants.APPConfiguration.LoggedIn)
//        performSegue(withIdentifier: Constants.Storyboard.loginSegue, sender: nil)
//        passwordTextField.text = ""
//        emailTextField.text = ""
//        else
//        present(getErrorAlert(), animated: true)
    }
    
    func getErrorAlert() -> UIAlertController {
        let errorAlert = UIAlertController(title: "Oops!", message: "These credentials don't look right. Make sure you entered the corrects ones and try again please.", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "Ok", style: .default))
        return errorAlert
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
