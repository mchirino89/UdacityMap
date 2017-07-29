//
//  Networking.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 28/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit

class Networking: NSObject {
    
    var session = URLSession.shared

    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
//    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
//        
//        /* 1. Set the parameters */
//        var parametersWithApiKey = parameters
//        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
//        
//        /* 2/3. Build the URL, Configure the request */
//        let request = NSMutableURLRequest(url: tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
//        
//        /* 4. Make the request */
//        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//            
//            func sendError(_ error: String) {
//                print(error)
//                let userInfo = [NSLocalizedDescriptionKey : error]
//                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
//            }
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                sendError("There was an error with your request: \(error!)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                sendError("Your request returned a status code other than 2xx!")
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                sendError("No data was returned by the request!")
//                return
//            }
//            
//            /* 5/6. Parse the data and use the data (happens in completion handler) */
//            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
//        }
//        
//        /* 7. Start the request */
//        task.resume()
//        
//        return task
//    }
}
