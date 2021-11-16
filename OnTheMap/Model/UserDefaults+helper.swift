//
//  UserDefaults+helper.swift
//  OnTheMap
//
//  Created by Brian Wilson on 11/11/21.
//

import Foundation

extension UserDefaults {
    
    enum Keys: String, CaseIterable {
        case firstName
        case lastName
        case isLoggedIn
        case uniqueKey
    }
    
    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue)}
    }
    
}
