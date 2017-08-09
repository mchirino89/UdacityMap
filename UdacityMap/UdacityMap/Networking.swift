//
//  Networking.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 28/7/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import UIKit

class Networking: NSObject {
    
    let session = URLSession.shared

    // authentication state
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // users id credentials
    var name = ""
    var lastName = ""
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod(host: Bool, path: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForGET: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        
        /* 2/3. Build the URL, Configure the request */
        
        let request = NSMutableURLRequest(url: URLFromParameters(host: host, path: path, parameters: parameters))
        request.addValue(Constants.APIConfiguration.AppId, forHTTPHeaderField: Constants.ParameterKeys.AppId)
        request.addValue(Constants.APIConfiguration.ApiKey, forHTTPHeaderField: Constants.ParameterKeys.ApiKey)
        
        /* 4. Make the request */
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("\(Constants.ErrorMessages.generic)\(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(Constants.ErrorMessages.noSuccess)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(Constants.ErrorMessages.noData)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, udacityAPI: host, completionHandlerForConvertData: completionHandlerForGET)
        }.resume()
    }
    
    // MARK: POST
    
    func taskForPOSTMethod(host: Bool, path: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: URLFromParameters(host: host, path: path, parameters: parameters))
        request.httpMethod = "POST"
        request.addValue(Constants.JSONBodyKeys.appJSON, forHTTPHeaderField: Constants.HTTPHeaderField.acceptance)
        request.addValue(Constants.JSONBodyKeys.appJSON, forHTTPHeaderField: Constants.HTTPHeaderField.content)
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String, statusCode: Int = 1) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: statusCode, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("\(Constants.ErrorMessages.generic)\(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print(response!.debugDescription)
                sendError(Constants.ErrorMessages.noSuccess, statusCode: (response as! HTTPURLResponse).statusCode)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(Constants.ErrorMessages.noData)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, udacityAPI: host, completionHandlerForConvertData: completionHandlerForPOST)
        }.resume()
    }
    
    // MARK: DELETE
    
    func taskForDELETEMethod(path: String, completionHandlerForPOST: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(url: URLFromParameters(host: true, path: path, parameters: [:]))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        xsrfCookie = sharedCookieStorage.cookies!.filter({ $0.name == "XSRF-TOKEN" })[0]
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: Constants.HTTPHeaderField.Token)
        }
        
        /* 4. Make the request */
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("\(Constants.ErrorMessages.generic)\(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(Constants.ErrorMessages.noSuccess)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(Constants.ErrorMessages.noData)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, udacityAPI: true, completionHandlerForConvertData: completionHandlerForPOST)
        }.resume()
    }
    
    // MARK: Network logic for Http request
    private func networkLogic(logicHandler: @escaping (Data?, URLResponse?, Error?) -> Void, udacityAPI: Bool, completionHandlerForRequest: @escaping (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        // I wanted to move the logic from http request into here but i didn't find a way to execute the closeru 'logicHandler' within this method. Could you please tell me how to do it?
//        logicHandler() {
//            (data, response, error) in
//        }
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, udacityAPI: Bool = false, completionHandlerForConvertData: (_ result: [String:AnyObject]?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            let newData = udacityAPI ? data.subdata(in: Range(5..<data.count)) : data
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "\(Constants.ErrorMessages.parsingJSON)'\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult as? [String : AnyObject], nil)
    }
    
    // create a URL from parameters
    private func URLFromParameters(host: Bool, path: String, parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.APIConfiguration.ApiScheme
        components.host = host ? Constants.URL.Udacity : Constants.URL.Parse
        components.path = path
        components.queryItems = [URLQueryItem]()
        
        for (key, pairValue) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(pairValue)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    class func sharedInstance() -> Networking {
        struct Singleton {
            static var sharedInstance = Networking()
        }
        return Singleton.sharedInstance
    }
}
