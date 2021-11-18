//
//  GetPublicUserDataResponse.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/15/21.
//

import Foundation

// GET Public User Data Response

//{
//    "last_name":"Wiegand",
//    "social_accounts":[],
//    "mailing_address":null,
//    "_cohort_keys":[],
//    "signature":null,
//    "_stripe_customer_id":null,
//    "guard":{},
//    "_facebook_id":null,
//    "timezone":null,
//    "site_preferences":null,
//    "occupation":null,
//    "_image":null,
//    "first_name":"Janis",
//    "jabber_id":null,
//    "languages":null,
//    "_badges":[],
//    "location":null,
//    "external_service_password":null,
//    "_principals":[],
//    "_enrollments":[],
//    "email":{
//        "address":"janis.wiegand@onthemap.udacity.com\",
//        "_verified":true,
//        "_verification_code_sent":true
//    },
//    "website_url":null,
//    "external_accounts":[],
//    "bio":null,
//    "coaching_data":null,
//    "tags":[],
//    "_affiliate_profiles":[],
//    "_has_password":true,
//    "email_preferences":null,
//    "_resume":null,
//    "key":"89268965125",
//    "nickname":"Janis Wiegand",
//    "employer_sharing":false,
//    "_memberships":[],
//    "zendesk_id":null,
//    "_registered":false,
//    "linkedin_url":null,
//    "_google_id":null,
//    "_image_url":"https://robohash.org/udacity-89268965125\"
//}


struct PublicUserDataResponse: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case uniqueKey = "key"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
