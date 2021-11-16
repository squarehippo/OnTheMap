//
//  PostSession.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/15/21.
//

import Foundation

// POST Session
//{
//    "udacity": {
//        "username": "account@domain.com",
//        "password": "********"
//    }
//}

struct PostSession {
    let udacity: PostSessionInfo
}

struct PostSessionInfo {
    let username: String
    let password: String
}

