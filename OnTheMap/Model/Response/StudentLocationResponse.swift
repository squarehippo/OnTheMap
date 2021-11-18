//
//  GetStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/15/21.
//

import Foundation

// GET Student Location Response

//"results":[
//       {
//           "createdAt":"2015-02-24T22:27:14.456Z",
//           "firstName":"Jessica",
//           "lastName":"Uelmen",
//           "latitude":28.1461248,
//           "longitude":-82.756768,
//           "mapString":"Tarpon Springs, FL",
//           "mediaURL":"www.linkedin.com/in/jessicauelmen/en",
//           "objectId":"kj18GEaWD8",
//           "uniqueKey":"872458750",
//           "updatedAt":"2015-03-09T22:07:09.593Z"
//       }
//   ]
//}


struct StudentLocationResponse: Codable {
    var results: [StudentInformation]
}

struct StudentInformation: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude: Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
}
