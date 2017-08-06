//
//  Constants.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 29/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit

class Constants {

    // MARK: Constants
    struct APIConfiguration {
        
        // MARK: API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        static let ApiScheme = "https"
        
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
        static let Parse = "parse.udacity.com/parse/classes"
    }
    
    struct Path {
        static let SignIn = "/api/session"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        static let Session = "session"
        
        // MARK: Account
        static let UserID = "id"
        static let Account = "account"
        static let Key = "key"
    }
}

func logOutUser(navigationController: UINavigationController?) {
    let questionAlert = UIAlertController(title: "Log out", message: "Are you sure you want to log out now?", preferredStyle: .actionSheet)
    let logOutAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
        UserDefaults.standard.removeObject(forKey: Constants.Session.Id)
        UserDefaults.standard.removeObject(forKey: Constants.Session.AccountKey)
        let _ = Networking.sharedInstance().taskForDELETEMethod(path: Constants.Path.SignIn) {
            (results, error) in
            if let error = error {
                print(error)
            } else {
                print(results!)
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
    questionAlert.addAction(logOutAction)
    questionAlert.addAction(UIAlertAction(title: "No", style: .default))
    navigationController?.present(questionAlert, animated: true)
}

// MARK: Sets custom navigation title
func getCustomTitle() -> UILabel {
    let titleLabel = UILabel()
    titleLabel.text = "On the map"
    titleLabel.font = UIFont(name: "MarkerFelt-Thin", size: 20)
    titleLabel.sizeToFit()
    return titleLabel
}
