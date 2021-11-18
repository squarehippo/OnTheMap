//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Brian Wilson on 10/29/21.
//

import Foundation

// POST Student Location
////
//{
//    "uniqueKey": "1234",
//    "firstName": "John",
//    "lastName": "Doe",
//    "mapString": "Mountain View, CA",
//    "mediaURL": "https://udacity.com",
//    "latitude": 37.386052,
//    "longitude": -122.083851
//}

struct PostStudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

