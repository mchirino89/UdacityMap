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
    
    private func setWaitinView(isOn: Bool) {
        isOn ? view.bringSubview(toFront: waitingVisualEffect) : view.sendSubview(toBack: waitingVisualEffect)
        waitingVisualEffect.alpha = isOn ? 1 : 0
    }
    
    func performLogin() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.setWaitinView(isOn: true)
        })
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            // Quick question: Is this the proper form to prevent a retain cycle in here?
            [unowned self] in
            let _ = Networking.sharedInstance().taskForPOSTMethod(URLExtension: "", host: true, path: Constants.Path.SignIn, parameters: [:], jsonBody: "{\"udacity\": {\"username\": \"\(self.emailTextField.text!)\", \"password\": \"\(self.passwordTextField.text!)\"}}") {
                (results, error) in
                if let error = error {
                    print(error)
                    DispatchQueue.main.async{
                        UIView.animate(withDuration: 0.3, animations: {
                            self.setWaitinView(isOn: false)
                        })
                        self.present(self.getErrorAlert(), animated: true)
                    }
                } else {
                    guard let JSONresponse = results else { return }
                    print(JSONresponse)
                    Networking.sharedInstance().sessionID = JSONresponse[Constants.JSONResponseKeys.Session]![Constants.JSONResponseKeys.UserID] as? String
                    Networking.sharedInstance().userID = Int(JSONresponse[Constants.JSONResponseKeys.Account]![Constants.JSONResponseKeys.Key] as! String)
                    UserDefaults.standard.set(Networking.sharedInstance().userID!, forKey: Constants.Session.AccountKey)
                    UserDefaults.standard.set(Networking.sharedInstance().sessionID!, forKey: Constants.Session.Id)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: Constants.Storyboard.loginSegue, sender: nil)
                        self.passwordTextField.text = ""
                        self.emailTextField.text = ""
                        self.setWaitinView(isOn: false)
                    }
                }
            }
        }
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
