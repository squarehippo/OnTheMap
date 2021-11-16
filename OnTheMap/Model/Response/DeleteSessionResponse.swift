//
//  DeleteSessionResponse.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/11/21.
//

import Foundation

// DELETE Session Response

//{
//  "session": {
//    "id": "1463940997_7b474542a32efb8096ab58ced0b748fe",
//    "expiration": "2015-07-22T18:16:37.881210Z"
//  }
//}

struct DeleteSessionResponse {
    let session: DeleteSession
}

struct DeleteSession {
    let id: String
    let expiration: String
}
