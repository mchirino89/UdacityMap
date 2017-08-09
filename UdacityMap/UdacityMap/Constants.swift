//
//  Constants.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 29/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit

class Constants {
    
    enum Host {
        case Udacity
        case Parse
    }
    
    
    struct APIConfiguration {
        static let ApiScheme = "https"
        static let URLScheme = "http"
        // MARK: API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    struct Session {
        static let Id = "session"
        static let AccountKey = "key"
    }
    
    struct Storyboard {
        static let studentCell = "studentListCell"
        static let loginSegue = "loggedSegue"
        static let loginView = "loginView"
        static let tabView = "tabView"
        static let navigationView = "navigationView"
    }
    
    // MARK: URLs
    struct URL {
        static let SignUp = "https://www.udacity.com/account/auth#!/signup"
        static let Udacity = "www.udacity.com"
        static let Parse = "parse.udacity.com"
    }
    
    // MARK: API routes
    struct Path {
        static let SignIn = "/api/session"
        static let Students = "/parse/classes/StudentLocation"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let AppId = "X-Parse-Application-Id"
        static let ApiKey = "X-Parse-REST-API-Key"
    }
    
    // MARK: Http header values
    struct HTTPHeaderField {
        static let content = "Content-Type"
        static let acceptance = "Accept"
        static let Token = "X-XSRF-TOKEN"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let appJSON = "application/json"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let Session = "session"
        
        // MARK: Account
        static let UserID = "id"
        static let Account = "account"
        static let Key = "key"
        
        // MARK: Studens
        static let results = "results"
        static let object = "objectId"
        static let id = "uniqueKey"
        static let name = "firstName"
        static let lastName = "lastName"
        static let info = "mapString"
        static let url = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let update = "updatedAt"
        static let creation = "createdAt"
    }
    
    struct UIElements {
        static let mapPin = "pin"
        static let customTitleFont = "MarkerFelt-Thin"
        static let noNameProvidedFont = "HelveticaNeue-Italic"
        static let nameProvidedFont = "HelveticaNeue"
    }
    
    struct ErrorMessages {
        static let credentials = "These credentials don't look right. Make sure you entered the corrects ones and try again please."
        static let internetConnection = "It seems you don't have an active internet connection right now. Make sure you do before you try again please"
        static let studentLocation = "Something went wrong loading the students' pins"
        static let newPinAddition = "Something went wrong while adding the pin. Try again later please"
        static let parsingJSON = "Could not parse the data as JSON: "
        static let noData = "No data was returned by the request!"
        static let noSuccess = "Your request returned a status code other than 2xx!"
        static let generic = "There was an error with your request: "
        static let popupTitle = "Oops!"
        static let popupButton = "Ok"
        static let noLocationFound = "No location found"
        static let noGPS = "It wasn't possible to get your location this time, please check your internet connection and try again later"
        static let previouslyDenied = "It seems you've previously denied sharing your location with UdacityMap. Please enable it so we can improve your overall experience and try again"
    }
    
    struct UIMessages {
        static let affirmative = "Yes"
        static let negative = "No"
        static let logout = "Log out"
        static let logoutQuestion = "Are you sure you want to log out now?"
        static let appTitle = "On the map"
        static let locationPermission = "Using your device's GPS, the app can get your current location for you. May it proceed?"
        static let pinConfirmation = "Do you wish to add this one as your location into Udacity's map?"
        static let overwritePin = "You already have added your location into the map, do you wish to overwrite it?"
        static let missingInfoTitle = "Attention"
        static let missingIngoMessage = "It seems you've skipped some information for your new location, are you completely sure you want to proceed? If no, just hit \"No\" and fill it before you try again"
    }
    
    struct Utilities {
        static let updateNotification = "com.3codegeeks.UdacityMap.updateNotification"
    }
}

let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return formatter
}()

func questionPopup(title: String, message: String, style: UIAlertControllerStyle, afirmativeAction: ((UIAlertAction) -> Void)?) -> UIAlertController {
    let questionAlert = UIAlertController(title: title, message: message, preferredStyle: style)
    let logOutAction = UIAlertAction(title: Constants.UIMessages.affirmative, style: .destructive, handler: afirmativeAction)
    questionAlert.addAction(logOutAction)
    questionAlert.addAction(UIAlertAction(title: Constants.UIMessages.negative, style: .default))
    return questionAlert
}

func logOutUser(navigationController: UINavigationController?) {
    let logoutConfirmation = questionPopup(title: Constants.UIMessages.logout, message: Constants.UIMessages.logoutQuestion, style: .actionSheet, afirmativeAction: { _ in
        // Removing local stored session keys
        UserDefaults.standard.removeObject(forKey: Constants.Session.Id)
        UserDefaults.standard.removeObject(forKey: Constants.Session.AccountKey)
        // Invalidating current user's cookie in the API
        Networking.sharedInstance().taskForDELETEMethod(path: Constants.Path.SignIn) {
            (results, error) in
            if let error = error {
                print(error)
            } else {
                print(results!)
            }
        }
        navigationController?.popToRootViewController(animated: true)
    })
    navigationController?.present(logoutConfirmation, animated: true)
}

func getErrorAlert(errorMessage: String) -> UIAlertController {
    let errorAlert = UIAlertController(title: Constants.ErrorMessages.popupTitle, message: errorMessage, preferredStyle: .alert)
    errorAlert.addAction(UIAlertAction(title: Constants.ErrorMessages.popupButton, style: .default))
    return errorAlert
}

func getCustomTitle() -> UILabel {
    let titleLabel = UILabel()
    titleLabel.text = Constants.UIMessages.appTitle
    titleLabel.font = UIFont(name: Constants.UIElements.customTitleFont, size: 20)
    titleLabel.sizeToFit()
    return titleLabel
}

func setWaitingView(isOn: Bool, waitingVisualEffect: UIVisualEffectView, view: UIView) {
    UIView.animate(withDuration: 0.3, animations: {
        isOn ? view.bringSubview(toFront: waitingVisualEffect) : view.sendSubview(toBack: waitingVisualEffect)
        waitingVisualEffect.alpha = isOn ? 1 : 0
    })
}

func removeWaitingView(waitingVisualEffect: UIVisualEffectView, view: UIView) {
    UIView.animate(withDuration: 0.3, animations: {
        waitingVisualEffect.alpha = 0
    }, completion: { _ in
        view.sendSubview(toBack: waitingVisualEffect)
    })
}

func launchSafari(studentsURL: String?, studentsFullName: String, navigationController: UINavigationController?) {
    let app = UIApplication.shared
    if let toOpen = studentsURL, (studentsURL!.hasPrefix(Constants.APIConfiguration.ApiScheme) || studentsURL!.hasPrefix(Constants.APIConfiguration.URLScheme)) {
        if app.canOpenURL(URL(string: toOpen)!) && toOpen.characters.count > 8 {
            app.open(URL(string: toOpen)!, options: [:], completionHandler: { (success) in
                print("\(success) for URL \(toOpen)")
            })
        } else {
            navigationController?.present(getErrorAlert(errorMessage: "\(studentsFullName) provided a missformatted URL"), animated: true)
        }
    } else {
        navigationController?.present(getErrorAlert(errorMessage: "\(studentsFullName) provided a missformatted URL"), animated: true)
    }
}
