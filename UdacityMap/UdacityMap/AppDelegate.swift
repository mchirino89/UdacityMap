//
//  AppDelegate.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 22/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        // Setting user session
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootView = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.navigationView)
        
        // If previosly logged, then skip login view
        if UserDefaults.standard.value(forKey: Constants.Session.Id) != nil {
            Networking.sharedInstance().name = (UserDefaults.standard.value(forKey: Constants.JSONResponseKeys.name) as? String)!
            Networking.sharedInstance().lastName = (UserDefaults.standard.value(forKey: Constants.JSONResponseKeys.lastName) as? String)!
            Networking.sharedInstance().sessionID = UserDefaults.standard.value(forKey: Constants.Session.Id) as? String
            Networking.sharedInstance().userID = UserDefaults.standard.value(forKey: Constants.Session.AccountKey) as? Int
            let tabView = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.tabView)
            (rootView as! UINavigationController).pushViewController(tabView, animated: false)
        }
        
        window?.rootViewController = rootView
        window?.makeKeyAndVisible()
        return true
    }

}
