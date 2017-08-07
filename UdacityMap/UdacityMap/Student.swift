//
//  Student.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 6/8/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import Foundation

// Is this the right place to put the students array? 
var studentsList:[Student] = []

struct Student {
    var objectId: String = ""
    var uniqueKey: String = ""
    var fullName: String = ""
    var mapString: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var updatedAt: String = ""
    var createdAt: String = ""
    
    init(dictionary: [String:AnyObject]) {
        var firstName: String = ""
        var lastName: String = ""
        if let object = dictionary[Constants.JSONResponseKeys.object] as? String {
            objectId = object
        }
        if let key = dictionary[Constants.JSONResponseKeys.id] as? String {
            uniqueKey = key
        }
        if let name = dictionary[Constants.JSONResponseKeys.name] as? String {
            firstName = name
        }
        if let last = dictionary[Constants.JSONResponseKeys.lastName] as? String {
            lastName = last
        }
        fullName = firstName + " " + lastName
        if let info = dictionary[Constants.JSONResponseKeys.info] as? String {
            mapString = info
        }
        if let url = dictionary[Constants.JSONResponseKeys.url] as? String {
            mediaURL = url
        }
        if let lat = dictionary[Constants.JSONResponseKeys.latitude] as? Double {
            latitude = lat
        }
        if let lon = dictionary[Constants.JSONResponseKeys.longitude] as? Double {
            longitude = lon
        }
        if let updated = dictionary[Constants.JSONResponseKeys.update] as? String {
            updatedAt = updated
        }
        if let created = dictionary[Constants.JSONResponseKeys.creation] as? String {
            createdAt = created
        }
    }
}
