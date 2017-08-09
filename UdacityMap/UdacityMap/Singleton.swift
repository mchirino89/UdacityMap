//
//  Singleton.swift
//  UdacityMap
//
//  Created by Mauricio Chirino on 9/8/17.
//  Copyright © 2017 3CodeGeeks. All rights reserved.
//

class StudentDataSource {
    var studentData = [Student]()
    static let sharedInstance = StudentDataSource()
    private init() {}
}
