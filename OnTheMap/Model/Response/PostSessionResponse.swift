//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/7/21.
//

import Foundation

// POST Session Response

//{
//    "account":{
//        "registered":true,
//        "key":"3903878747"
//    },
//    "session":{
//        "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
//        "expiration":"2015-05-10T16:48:30.760460Z"
//    }
//}

struct PostSessionResponse: Codable {
    let account: StudentAccount
    let session: SessionInformation
}

struct StudentAccount: Codable {
    let registered: Bool
    let key: String
}

struct SessionInformation: Codable {
    let id: String
    let expiration: String
}
