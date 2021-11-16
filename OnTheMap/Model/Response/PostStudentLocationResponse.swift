//
//  PostStudentInfoResponse.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/6/21.
//

import Foundation

// POST Student Location Response

//{
//    "createdAt":"2015-03-11T02:48:18.321Z",
//    "objectId":"CDHfAy8sdp"
//}

struct PostStudentLocationResponse: Codable {
    let createdAt: String
    let objectId: String
}

