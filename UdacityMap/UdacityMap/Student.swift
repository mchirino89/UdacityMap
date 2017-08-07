//
//  Student.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 6/8/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

import Foundation

struct Student {
    let objectId: String
    let uniqueKey: Int
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let updatedAt: String
    let ACL: String
    
    init(dictionary: [String:AnyObject]) {
        objectId = ""
        uniqueKey = 0
        firstName = ""
        lastName = ""
        mapString = ""
        mediaURL = ""
        latitude = 0.0
        longitude = 0.0
        updatedAt = ""
        ACL = ""
    }
}
