//
//  UserInformation.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/9/21.
//

import Foundation

// Get Public User Data
// https://onthemap-api.udacity.com/v1/users/<user_id>


struct PublicUserData: Codable {
    let firstName: String
    let lastName: String
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}

